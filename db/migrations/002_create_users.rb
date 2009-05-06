class CreateUsers < Sequel::Migration
  
  def up
    create_table :users do
      primary_key :id, :type => :Integer
      foreign_key :blog_id, :blogs, :type => :Integer
      String :name
      String :username
      String :password
      String :email
      TrueClass :email_updates, :default => true
      String :salt
    end
  end
  
  def down
    drop_table :users 
  end
  
end