class CreateUsers < Sequel::Migration
  
  def up
    create_table :users do
      primary_key :id, :type => :Integer
      foreign_key :blog_id, :blogs, :type => :Integer
      String :name
      String :openid
      String :email
      String :remember_me_token
      TrueClass :email_updates, :default => true
    end
  end
  
  def down
    drop_table :users 
  end
  
end