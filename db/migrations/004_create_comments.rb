class CreateComments < Sequel::Migration
  
  def up
    create_table :comments do
      primary_key :id, :type => :Integer
      foreign_key :post_id, :posts, :type => :Integer
      String :name
      String :website
      String :email
      String :body
      DateTime :created_at
      String :ip_address
    end
  end
  
  def down
    drop_table :comments 
  end
  
end