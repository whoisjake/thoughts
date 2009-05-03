class CreateUsers < Sequel::Migration
  
  def up
    create_table :users do
      primary_key :id, :type => :Integer
      String :username
      String :password
      String :salt
      String :email
    end
  end
  
  def down
    drop_table :users 
  end
  
end