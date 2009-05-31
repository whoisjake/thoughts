class User < Sequel::Model
  many_to_one :blog
  one_to_many :posts
  
  def self.find_by_openid(openid_url)
    User.filter(:openid.like("#{openid_url}%")).first
  end
  
  def to_s
    self.username
  end
  
end