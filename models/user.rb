require 'digest/md5'
class User < Sequel::Model
  many_to_one :blog
  one_to_many :posts
  attr_accessor :raw_password
  
  def before_create
    return false if super == false
    encrypt_password
  end
  
  private
  
  def encrypt_password
    # create_salt
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.username}--")
    # hash and store
    self.password = Digest::SHA1.hexdigest("--#{self.salt}--#{self.raw_password}--")
  end
  
end