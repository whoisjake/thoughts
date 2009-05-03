class Tag < Sequel::Model
  one_to_many :taggings
  one_to_many :posts
  
  def before_save
    return false if super == false
    self.name = self.name.downcase
  end
end