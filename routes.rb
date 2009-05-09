before do
  @blog = Blog.default
  
  new_params = {}
  params.each_pair do |full_key, value|
    this_param = new_params
    split_keys = full_key.split(/\]\[|\]|\[/)
    split_keys.each_index do |index|
      break if split_keys.length == index + 1
      this_param[split_keys[index]] ||= {}
      this_param = this_param[split_keys[index]]
   end
   this_param[split_keys.last] = value
  end
  request.params.replace new_params
end

not_found do
  erb :four_oh_four
end

helpers do
  def redirect_to(url)
    redirect url
  end
  
  def rss_feed(blog)
    blog.external_rss_feed || '/rss'
  end
  
  def comments_feed(blog)
    '/comments/rss'
  end
  
  def h(content)
    ERB::Util::h(content)
  end
end

get '/rss' do
  @posts = Post.filter(:published => true).order(:published_at.desc).limit(10)
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title @blog.title
        xml.description @blog.tagline
        xml.link "http://#{request.host}/"

        @posts.each do |post|
          xml.item do
            xml.title post.title
            xml.link "http://#{request.host}/#{post.permalink}"
            xml.description post.body.to_html
            xml.pubDate Time.parse(post.published_at.to_s).rfc822()
            xml.guid "http://#{request.host}/#{post.permalink}"
            xml.tag!("dc:creator", post.user.name) if post.user
          end
        end
      end
    end
  end
end

get '/comments/rss' do
  @comments = Comment.filter(:published => true).order(:created_at.desc).limit(10)
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "#{@blog.title} Comments"
        xml.description @blog.tagline
        xml.link "http://#{request.host}/"

        @comments.each do |comment|
          xml.item do
            xml.title "Re: #{comment.post.title}"
            xml.link "http://#{request.host}/#{comment.post.permalink}"
            xml.description comment.body
            xml.pubDate Time.parse(comment.created_at.to_s).rfc822()
            xml.guid "http://#{request.host}/#{comment.post.permalink}##{comment.id}"
            xml.tag!("dc:creator", comment.name) if comment.name
          end
        end
      end
    end
  end
end

get '/admin' do
  erb :admin, :layout => :admin_layout
end

get '/admin/posts' do
  # show posts
  @posts = Post.order(:created_at.desc).limit(10).all
  erb :admin_posts, :layout => :admin_layout
end

get '/admin/posts/new' do
  erb :admin_new, :layout => :admin_layout
end

get '/admin/posts/:id' do
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  erb :admin_post, :layout => :admin_layout
end

post '/admin/posts' do
  # create post
  @post = Post.new(params["post"])
  @post.user = Blog.default.users.first
  @post.tags = params["tags"]
  @post.publish! if (params["post"]["published"] == "published")
  @post.save
  redirect_to '/admin/posts'
end

put '/admin/posts/:id' do
  @post = Post[params[:id].to_i]
  halt 404, "Post not found" unless @post
  @post.body = params["post"]["body"]
  @post.save
  redirect_to "#{@post.permalink}"
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
  erb :admin_comments, :layout => :admin_layout
end

get '/admin/comments/:id' do
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  erb :admin_comment, :layout => :admin_layout
end

put '/admin/comments/:id' do
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
  @comment = Comment[params[:id].to_i]
  halt 404, "Comment not found" unless @comment
  @comment.delete
  redirect_to '/admin/comments'
end

get '/' do
  @posts = Post.filter(:published => true).order(:published_at.desc).limit(10)
  @posts.each {|p| puts p.body + " " + p.to_html }
  erb :posts
end

get '/tags' do
  @tags = Tag.all
  erb :tags
end

get %r{\A\/tags\/([\w]+)\z} do
  tag = params[:captures][0]
  @posts =
  erb :archive
end

get %r{\A\/([0-9]{4})\/?\z} do
  start_date = DateTime.parse("#{params[:captures][0]}/1/1")
  end_date = DateTime.parse("#{params[:captures][0]}/12/31")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end

get %r{\A\/([0-9]{4})\/([0-9]{2})\/?\z} do
  start_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/1")
  end_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/31")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end


get %r{\A\/([0-9]{4})\/([0-9]{2})\/([0-9]{2})\/?\z} do
  start_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/#{params[:captures][2]}")
  end_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/#{params[:captures][2]}")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end

post '*/comments' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  
  @comment = Comment.new(params["comment"])
  @comment.save
  
  redirect_to "#{@post.permalink}"
end

get '*' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  erb :post
end