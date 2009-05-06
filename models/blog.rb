class Blog < Sequel::Model
  one_to_many :users
  
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