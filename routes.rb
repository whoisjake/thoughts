before do
  @blog = Blog.default
end

get '/admin' do
  # show activity
  erb :admin
end

get '/admin/posts' do
  # show posts
  @posts = Post.filter(:published => true).order(:published_at.desc).limit(10)
  erb :admin_posts
end

get '/admin/posts/:id' do
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  redirect_to "/#{@post.permalink}"
end

post '/admin/posts' do
  # create post
  redirect_to '/admin/posts'
end

put '/admin/posts/:id' do
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  @post.body = params[:post][:body]
  @post.save
  redirect_to "/#{@post.permalink}"
end

delete '/admin/posts/:id' do
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  @post.delete
  redirect_to '/admin/posts'
end

get '/admin/comments' do
  # show comments
  @comments = Comment.all.order(:created_at.desc).limit(10)
  erb :admin_comments
end

get '/admin/comments/:id' do
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  erb :admin_comment
end

put '/admin/comments/:id' do
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  
  @comment.body = params[:comment][:body]
  @comment.name = params[:comment][:name]
  @comment.email = params[:comment][:email]
  @comment.website = params[:comment][:website]
  @comment.save
  
  redirect_to "/admin/comments/#{@comment.id}"
end

delete '/admin/comments/:id' do
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  @comment.delete
  redirect_to '/admin/comments'
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
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  
  @comment = Comment.new(params[:comment])
  @comment.save
  
  redirect_to "/#{@post.permalink}"
end

get '/*' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  erb :post
end