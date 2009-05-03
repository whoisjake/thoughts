class User < Sequel::Model
  many_to_one :blog
  one_to_many :posts
end