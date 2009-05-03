class Tag < Sequel::Model
  one_to_many :taggings
  one_to_many :posts
end