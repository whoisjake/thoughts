class Blog < Sequel::Model
  one_to_many :users
  
  def self.default
    Blog.first
  end
end