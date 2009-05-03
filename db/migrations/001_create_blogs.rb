class CreateBlogs < Sequel::Migration
  
  def up
    create_table :blogs do
      primary_key :id, :type => :Integer
      String :title
      String :tagline
    end
    
    @db[:blogs].insert(:title => "My Awesome Blog", :tagline => "The best blog in the whole wide world.")
  end
  
  def down
    drop_table :blogs 
  end
  
end