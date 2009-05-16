describe 'The thoughts App' do
  include Sinatra::Test
  
  before(:each) do
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @user = User.create :blog => @blog, :openid => "http://whoisjake.myopenid.com", :name => "Jake Good"
  end

  it "displays a list of posts from the root path." do
    get '/'
    response.should be_ok
  end
  
  it "displays a list of posts in an rss feed." do
    get '/rss'
    response.should be_ok
    response["Content-Type"].should == "application/xml;charset=utf-8"
  end
  
  it "displays a list of comments in an rss feed." do
    get '/comments/rss'
    response.should be_ok
    response["Content-Type"].should == "application/xml;charset=utf-8"
  end
  
  it "displays a list of tags." do
    get '/tags'
    response.should be_ok
  end
  
  it "displays a list of tags." do
    get '/tags'
    response.should be_ok
  end
  
  it "displays a list of articles that have one tag." do
    get '/tags/my_tag'
    response.should be_ok
  end
  
  it "displays archived posts" do
    today = Time.now.utc
    
    get "/#{today.year}"
    response.should be_ok
    
    get "/#{today.year}/#{Post.pad(today.month)}"
    response.should be_ok
    
    get "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}"
    response.should be_ok
  end
  
  it "displays a single post." do
    today = Time.now.utc
    post = Post.new
    post.title = "My Blog Post"
    post.body = "My post body."
    post.user = @user
    post.publish!
    post.save
    
    post.permalink.should == "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}/my-blog-post"
    get "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}/my-blog-post"
    response.should be_ok
  end
  
  it "can post a comment." do
    today = Time.now.utc
    post = Post.new
    post.title = "My Blog Post"
    post.body = "My post body."
    post.user = @user
    post.publish!
    post.save
    
    get "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}/my-blog-post"
    response.should be_ok
    
    post "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}/my-blog-post/comments", { :comment => { :name => "Jake", :body => "comment"} }
    response.should be_redirect
    
    post.refresh
    post.comments.size.should == 1
    comment = post.comments.first
    
    comment.body.should == "comment"
    comment.name.should == "Jake"
    comment.post.should == post
    comment.published.should be_true
  end
  
  it "does not publish a spam comment." do
    today = Time.now.utc
    post = Post.new
    post.title = "My Blog Post"
    post.body = "My post body."
    post.user = @user
    post.publish!
    post.save
    
    get "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}/my-blog-post"
    response.should be_ok
    
    post "/#{today.year}/#{Post.pad(today.month)}/#{Post.pad(today.day)}/my-blog-post/comments", { :comment => { :name => "Jake", :body => "buy my cheap sexy gay porn viagra"} }
    response.should be_redirect
    
    post.refresh
    post.comments.size.should == 1
    
    comment = post.comments.first
    
    comment.body.should == "buy my cheap sexy gay porn viagra"
    comment.name.should == "Jake"
    comment.post.should == post
    comment.published.should be_false
  end
  
  it "gives a 404" do
    get "/some_random_url"
    response.should be_not_found
  end
  
end