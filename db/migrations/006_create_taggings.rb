class CreateTaggings < Sequel::Migration
  
  def up
    create_table :taggings do
      primary_key :id, :type => :Integer
      foreign_key :tag_id, :tags, :type => :Integer
      foreign_key :post_id, :posts, :type => :Integer
    end
  end
  
  def down
    drop_table :taggings 
  end
  
end