class CreateBlogs < Sequel::Migration
  
  def up
    create_table :blogs do
      primary_key :id, :type => :Integer
      String :title
      String :tagline
      String :permalink
      String :external_rss_feed
    end
    
    @db[:blogs].insert(:title => "My Awesome Blog", :tagline => "The best blog in the whole wide world.", :permalink => "/:year/:month/:day/:title")
  end
  
  def down
    drop_table :blogs 
  end
  
end