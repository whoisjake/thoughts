class CreatePosts < Sequel::Migration
  
  def up
    create_table :posts do
      primary_key :id, :type => :Integer
      String :title
      String :body
      DateTime :created_at
      foreign_key :user_id, :users, :type => :Integer
      String :permalink
    end
  end
  
  def down
    drop_table :posts 
  end
  
end