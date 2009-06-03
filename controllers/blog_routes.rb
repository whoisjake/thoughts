get '/rss' do
  @posts = Post.filter(:published => true).order(:published_at.desc).limit(15)
  content_type 'application/xml', :charset => 'utf-8'
  feed = builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title h(@blog.title)
        xml.description h(@blog.tagline)
        xml.link @blog.domain

        @posts.each do |post|
          xml.item do
            xml.title h(post.title)
            xml.link "#{@blog.domain}/#{post.permalink}"
            xml.description post.to_html
            xml.pubDate Time.parse(post.published_at.to_s).rfc822()
            xml.guid "#{@blog.domain}/#{post.permalink}"
            xml.tag!("dc:creator", post.user.name) if post.user
          end
        end
      end
    end
  end
  cache(feed)
end

get '/comments/rss' do
  @comments = Comment.filter(:published => true).order(:created_at.desc).limit(15)
  content_type 'application/xml', :charset => 'utf-8'
  feed = builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "#{h(@blog.title)} Comments"
        xml.description h(@blog.tagline)
        xml.link @blog.domain

        @comments.each do |comment|
          xml.item do
            xml.title "Re: #{h(comment.post.title)}"
            xml.link "#{@blog.domain}/#{comment.post.permalink}"
            xml.description h(comment.body)
            xml.pubDate Time.parse(comment.created_at.to_s).rfc822()
            xml.guid "#{@blog.domain}/#{comment.post.permalink}##{comment.id}"
            xml.tag!("dc:creator", h(comment.name)) if comment.name
          end
        end
      end
    end
  end
  cache(feed)
end

get '/' do
  @posts = Post.filter(:published => true).order(:published_at.desc).paginate(params[:page] || 1, 10)
  cache(erb(:posts))
end

get '/tags' do
  @tags = Tag.all
  @taggings = Tagging.all
  
  @tag_map = {}
  @taggings.each do |tagging|
    count = @tag_map[tagging.tag_id] || 0
    count += 1
    @tag_map[tagging.tag_id] = count
  end
  
  cache(erb(:tags))
end

get %r{\A\/tags\/([\w]+)\z} do
  tag = Tag.filter(:name => params[:captures][0].downcase).first
  @posts = []
  
  if tag
    @message = "Posts tagged with #{tag.name}"
    taggings = Tagging.filter(:tag_id => tag.id).select(:post_id)
    @posts = Post.filter({:published => true} & {:id => taggings}).order(:published_at.desc)
    cache(erb(:archive))
  else
    halt 404, "Tag not found"
  end

end

get %r{\A\/([0-9]{4})\/?\z} do
  @posts = filter_posts_by_date(params[:captures])
  @message = "Posts created in #{params[:captures][0]}"
  cache(erb(:archive))
end

get %r{\A\/([0-9]{4})\/([0-9]{1,2})\/?\z} do
  @posts = filter_posts_by_date(params[:captures])
  @message = "Posts created in #{params[:captures][1]}/#{params[:captures][0]}"
  cache(erb(:archive))
end


get %r{\A\/([0-9]{4})\/([0-9]{1,2})\/([0-9]{2})\/?\z} do
  @posts = filter_posts_by_date(params[:captures])
  @message = "Posts created on #{params[:captures][1]}/#{params[:captures][2]}/#{params[:captures][0]}"
  cache(erb(:archive))
end

post '*/comments' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  
  @comment = Comment.new(params["comment"])
  @comment.post = @post
  @comment.created_at = Time.now.utc
  @comment.save
  
  #expire index, post
  
  redirect_to "#{@post.permalink}"
end

get '*' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  cache(erb(:post))
end