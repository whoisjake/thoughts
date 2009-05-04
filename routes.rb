get '/' do
  @blog = Blog.default
  @posts = Post.filter(:published).order(:created_at.desc).limit(10)
  erb :posts
end

get '/admin' do
end

get '/admin/posts' do
end

get '/admin/comments' do
end

get %r{\/[0-9]{4}} do
end

get %r{\/[0-9]{4}\/[0-9]{2}} do
end

get %r{\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}} do
end

get '/*' do
end