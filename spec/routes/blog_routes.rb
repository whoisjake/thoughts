describe 'The thoughts App' do
  include Sinatra::Test

  it "displays a list of posts from the root path." do
    get '/'
    response.should be_ok
  end
end