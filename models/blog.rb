require 'digest/md5'
class Blog < Sequel::Model
  one_to_many :users
  
  def before_create
    return false if super == false
    self.permalink = "/:year/:month/:day/:title" if self.permalink.nil? || self.permalink.empty?
    self.theme ||= "default" if self.theme.nil? || self.theme.empty?
    self.external_rss_feed = nil if !self.external_rss_feed.nil? && self.external_rss_feed.empty?
    self.secret = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.title}--#{self.tagline}--")
  end
  
  def self.default
    Blog.first
  end
  
  def rss_feed
    self.external_rss_feed || "/rss"
  end
  
  def comments_feed
    "/comments"
  end
  
end