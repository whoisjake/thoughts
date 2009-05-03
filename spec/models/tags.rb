require File.dirname(__FILE__) + '/../test_helper'

describe Tag do
  
  before(:all) do
    Blog.delete
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @blog.save
    @user = User.create :blog => @blog, :username => "jake", :raw_password => "password"
  end
  
  before(:each) do
    Post.delete
    Tag.delete
    Tagging.delete
    @post = Post.new :title => "My Test Post", :body => "Test Post Body", :user => @user
    @tag = Tag.new
  end
  
  it "can set values." do
    @tag.name = "Test"
  end
  
  it "can be saved." do
    @tag.name = "Test"
    @tag.save
    @tag.name.should == "test"
  end

end