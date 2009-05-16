require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  before(:each) do
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @user = User.new
  end
  
  it "can set values." do
    @user.name = "Jake Good"
    @user.email = "jake@whoisjake.com"
    @user.email_updates = true
    @user.openid = "http://whoisjake.myopenid.com"
  end
  
  it "can be saved." do
    @user.name = "Jake Good"
    @user.email = "jake@whoisjake.com"
    @user.email_updates = true
    @user.openid = "http://whoisjake.myopenid.com"
    @user.save
  end
  
  it "can be associated to a blog." do
    @user.name = "Jake Good"
    @user.email = "jake@whoisjake.com"
    @user.email_updates = true
    @user.openid = "http://whoisjake.myopenid.com"
    @user.save
    
    @user.blog = @blog
    @user.save
    
    @blog.users.should include(@user)
    @user.blog.should == @blog
  end

end