class Post < Sequel::Model
  many_to_one :user
  one_to_many :comments
  one_to_many :taggings
end