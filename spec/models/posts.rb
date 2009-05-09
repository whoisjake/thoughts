require File.dirname(__FILE__) + '/../spec_helper'

describe Post do
  
  before(:all) do
    Blog.delete
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @blog.save
    @user = User.create :blog => @blog, :username => "jake", :raw_password => "password"
  end
  
  before(:each) do
    Tag.delete
    Tagging.delete
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
    @post.permalink.should == "/#{published_at.year}/#{Post.pad(published_at.month)}/#{Post.pad(published_at.day)}/my-post-title"
  end
  
  it "creates and utilizes the correct set of tags." do
    t = Tag.create(:name => "one")
    @post.title = "My Post Title"
    @post.body = "Test Body"
    @post.user = @user
    @post.publish!
    @post.tags = "one, two, three, THREE"
    @post.save
    
    Tag.count.should == 3
    Tagging.count.should == 3
    
    @post.reload
    @post.tags.size.should == 3
    @post.tags.should include('one')
    @post.tags.should include('two')
    @post.tags.should include('three')
    
    @post.save
    @post.reload
    @post.tags.size.should == 3
    @post.tags.should include('one')
    @post.tags.should include('two')
    @post.tags.should include('three')
    
    @post.tags = "one"
    @post.save
    @post.reload
    @post.tags.size.should == 1
    @post.tags.should == ['one']
    
    @post.tags = "one, two"
    @post.save
    @post.reload
    @post.tags.size.should == 2
    @post.tags.should == ['one', 'two']
    @post.tags.should include('one')
    @post.tags.should include('two')
  end
  
  it "should create valid HTML using Markdown" do
    @post.title = "Test Markdown Post"
    body = "[Test Link][1]\n\n[1]: http://testlink.com \"Test Link\""
    @post.body = body
    @post.user = @user
    @post.to_html.should == "<p><a href='http://testlink.com' title='Test Link'>Test Link</a></p>".strip
  end

end