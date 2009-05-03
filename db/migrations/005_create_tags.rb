class CreateTags < Sequel::Migration
  
  def up
    create_table :tags do
      primary_key :id, :type => :Integer
      String :name
    end
  end
  
  def down
    drop_table :tags 
  end
  
end