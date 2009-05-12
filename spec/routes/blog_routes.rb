describe 'The thoughts App' do
  include Sinatra::Test
  
  before(:each) do
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @user = User.create :blog => @blog, :username => "jake", :raw_password => "password"
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
  
end