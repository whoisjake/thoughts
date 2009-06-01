get '/admin/login' do
  erb :login, :layout => :admin_layout
end
 
post '/admin/login' do
  if resp = request.env["rack.openid.response"]
    case resp.status
      when :success
        options.logger.info "#{resp.inspect}" if options.logger
        user = User.find_by_openid(resp.identity_url)
        
        if user
          session["identity_url"] = resp.identity_url
          session["authenticated"] = true
        end
        
      when :failure
        session["authenticated"] = false
    end
  else
    if User.find_by_openid(params["openid_identifier"])
      headers 'WWW-Authenticate' => Rack::OpenID.build_header(
        :identifier => params["openid_identifier"]
      )
      throw :halt, [401, 'OpenID is required.']
    end
  end
  
  if session["authenticated"]
    redirect_to "/admin"
  else
    redirect_to "/admin/login"
  end
end

get '/admin' do
  authenticate
  erb :admin, :layout => :admin_layout
end

get '/admin/posts' do
  authenticate
  # show posts
  @posts = Post.order(:created_at.desc).paginate(params[:page] || 1, 10)
  erb :admin_posts, :layout => :admin_layout
end

get '/admin/posts/new' do
  authenticate
  erb :admin_new, :layout => :admin_layout
end

get '/admin/posts/:id' do
  authenticate
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  erb :admin_post, :layout => :admin_layout
end

post '/admin/posts' do
  authenticate
  
  # create post
  @post = Post.new(params["post"])
  @post.user = Blog.default.users.first
  @post.tags = params["tags"]
  @post.created_at = Time.now.utc
  @post.publish! if (params["post"]["published"] == "published")
  @post.save
  redirect_to '/admin/posts'
end

put '/admin/posts/:id' do
  authenticate
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  @post.body = params["post"]["body"]
  @post.save
  redirect_to "#{@post.permalink}"
end

delete '/admin/posts/:id' do
  authenticate
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  @post.delete
  redirect_to '/admin/posts'
end

get '/admin/comments' do
  authenticate
  # show comments
  @comments = Comment.all.order(:created_at.desc).paginate(params[:page] || 1, 10)
  erb :admin_comments, :layout => :admin_layout
end

get '/admin/comments/:id' do
  authenticate
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  erb :admin_comment, :layout => :admin_layout
end

put '/admin/comments/:id' do
  authenticate
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  
  @comment.body = params["comment"]["body"]
  @comment.name = params["comment"]["name"]
  @comment.email = params["comment"]["email"]
  @comment.website = params["comment"]["website"]
  @comment.save
  
  redirect_to "/admin/comments/#{@comment.id}"
end

delete '/admin/comments/:id' do
  authenticate
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  @comment.delete
  redirect_to '/admin/comments'
end