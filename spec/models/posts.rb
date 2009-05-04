require File.dirname(__FILE__) + '/model_helper'

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
    @post.save
    
    @post.published_at.should be_nil
    @post.permalink.should be_nil
    @post.created_at.should be_close(Time.now.utc, 3)
  end
  
  it "creates a correct permalink." do
    @post.title = "My Post Title"
    @post.body = "Test Body"
    @post.user = @user
    @post.publish!
    @post.save
    
    @post.published_at.should_not be_nil
    @post.permalink.should_not be_nil
    @post.published_at.should be_close(Time.now.utc, 3)
    
    published_at = @post.published_at
    @post.permalink.should == "/#{published_at.year}/#{published_at.month.pad}/#{published_at.day.pad}/my-post-title"
  end

end