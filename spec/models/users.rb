require File.dirname(__FILE__) + '/../test_helper'

describe User do
  
  before(:all) do
    Blog.delete
    @blog = Blog.new :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @blog.save
  end
  
  before(:each) do
    @user = User.new
    User.delete
  end
  
  it "can set values." do
    @user.username = "jake"
    @user.raw_password = "my_raw_password"
    @user.salt = "salt of the land"
    @user.password = "crypted password"
  end
  
  it "can be saved." do
    @user.username = "jake"
    @user.raw_password = "my_raw_password"
    @user.should_receive(:encrypt_password)
    @user.save
  end
  
  it "can be associated to a blog." do
    @user.username = "jake"
    @user.raw_password = "my_raw_password"
    @user.should_receive(:encrypt_password)
    @user.save
    
    @user.blog = @blog
    @user.save
    
    @blog.users.should include(@user)
    @user.blog.should == @blog
  end

end