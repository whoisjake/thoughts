class CreateBlogs < Sequel::Migration
  
  def up
    create_table :blogs do
      primary_key :id, :type => :Integer
      String :title
      String :tagline
      String :permalink
      String :external_rss_feed
      String :theme
      String :domain
      String :secret
    end
    
  end
  
  def down
    drop_table :blogs 
  end
  
end