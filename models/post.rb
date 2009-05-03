class Post < Sequel::Model
  many_to_one :user
  one_to_many :comments
  one_to_many :taggings
  
  def before_create
    return false if super == false
    # Set created_at
    self.created_at = Time.now.utc
    # Set permalink
    self.permalink = Post.create_permalink(self.title,self.created_at)
  end
  
  def self.create_permalink(title,created_at)
    permalink = Blog.default.permalink.gsub(/:year/, created_at.year.to_s)
    
    permalink.gsub!(/:month/, created_at.month.pad)
    permalink.gsub!(/:day/, created_at.day.pad)

    title.gsub!(/\W+/, ' ')
    title.strip!
    title.downcase!
    title.gsub!(/\ +/, '-')
    permalink.gsub!(/:title/,title)
    
    permalink
  end
  
end