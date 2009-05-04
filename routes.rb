before do
  @blog = Blog.default
end

get '/admin' do
  # show activity
end

get '/admin/posts' do
  # show posts
end

get '/admin/posts/:id' do
  # show post
end

post '/admin/posts' do
  # create post
end

put '/admin/posts/:id' do
  # edit post
end

delete '/admin/posts/:id' do
  # delete post
end

get '/admin/comments' do
  # show comments
end

get '/admin/comments/:id' do
  # show comment
end

post '/admin/comments' do
  # create comment
end

put '/admin/comments/:id' do
  # edit comment
end

delete '/admin/comments/:id' do
  # delete comment
end

get '/' do
  @posts = Post.filter(:published => true).order(:published_at.desc).limit(10)
  erb :posts
end

get %r{\A\/([0-9]{4})\/?} do
  start_date = DateTime.parse("#{params[:captures][0]}/1/1")
  end_date = DateTime.parse("#{params[:captures][0]}/12/31")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end

get %r{\A\/([0-9]{4})\/([0-9]{2})\/?} do
  start_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/1")
  end_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/31")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end


get %r{\A\/([0-9]{4})\/([0-9]{2})\/([0-9]{2})\/?} do
  start_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/#{params[:captures][2]}")
  end_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/#{params[:captures][2]}")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end

post '/*/comments' do
  # creates a comment
end

get '/*' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  erb :post
end