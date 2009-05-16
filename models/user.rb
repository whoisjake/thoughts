class User < Sequel::Model
  many_to_one :blog
  one_to_many :posts
  
  def to_s
    self.username
  end
  
end