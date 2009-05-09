class Post < Sequel::Model
  many_to_one :user
  one_to_many :comments
  one_to_many :taggings
  
  def before_create
    return false if super == false
    # Set created_at
    self.created_at = Time.now.utc
  end
  
  def after_save
    return false if super == false
    
    # create tags
    self.taggings_dataset.delete
    
    self.tags.each do |new_tag|
      tag = Tag.filter(:name => new_tag.downcase).first
      if tag.nil?
        tag = Tag.create(:name => new_tag)
      end
      Tagging.create(:tag => tag, :post => self)
    end
    
  end
  
  def to_html
    Maruku.new(self.body).to_html
  end
  
  def tags=(value)
    @tag_list = value.split(",").map{ |name| name.gsub(/[^\w\s_-]/i,"").strip.downcase }.uniq.sort
  end
  
  def tags
    @tag_list ||= self.taggings.collect{|tagging| tagging.tag.name }.sort
  end
  
  def publish!
    # Set published
    self.published = true
    # Set published date
    self.published_at = Time.now.utc
    # Set permalink
    self.permalink = Post.create_permalink(self.title,self.published_at)
  end
  
  def self.create_permalink(title, published_at)
    permalink = Blog.default.permalink.gsub(/:year/, published_at.year.to_s)
    
    permalink.gsub!(/:month/, Post.pad(published_at.month))
    permalink.gsub!(/:day/, Post.pad(published_at.day))

    subtitle = title.gsub(/\W+/, ' ')
    subtitle.strip!
    subtitle.downcase!
    subtitle.gsub!(/\ +/, '-')
    permalink.gsub!(/:title/,subtitle)
    
    permalink
  end
  
  def self.pad(number)
    number.to_s.length == 1 ? "0#{number}" : number.to_s
  end
  
end