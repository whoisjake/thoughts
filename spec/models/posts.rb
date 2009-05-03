require File.dirname(__FILE__) + '/../test_helper'

describe Post do
  
  before(:all) do
    Blog.delete
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @blog.save
    @user = User.create :blog => @blog, :username => "jake", :raw_password => "password"
  end
  
  before(:each) do
    Post.delete
    @post = Post.new
  end
  
  it "can set values." do
    @post.title = "My Post Title"
    @post.body = "My Post Body"
    @post.user = @user
    @post.permalink = "/my/perma/link"
  end
  
  it "can be saved." do
    @post.title = "My Post Title"
    @post.body = "My Post Body"
    @post.user = @user
    @post.permalink = "/my/perma/link"
    @post.save
  end
  
  it "creates a correct permalink." do
    @post.title = "My Post Title"
    @post.body = "Test Body"
    @post.user = @user
    @post.save
    
    created_at = @post.created_at
    @post.permalink.should == "/#{created_at.year}/#{created_at.month.pad}/#{created_at.day.pad}/my-post-title"
  end

end