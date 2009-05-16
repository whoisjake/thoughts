require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  
  before(:each) do
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @user = User.create :blog => @blog, :openid => "http://whoisjake.myopenid.com", :name => "Jake Good"
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
  
  it "can save with rules." do
    @tag.name = "Test Test"
    @tag.save
    @tag.name.should == "test-test"
  end

end