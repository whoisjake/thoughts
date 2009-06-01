get '/rss' do
  @posts = Post.filter(:published => true).order(:published_at.desc).limit(15)
  content_type 'application/xml', :charset => 'utf-8'
  builder do |xml|
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
end

get '/comments/rss' do
  @comments = Comment.filter(:published => true).order(:created_at.desc).limit(15)
  content_type 'application/xml', :charset => 'utf-8'
  builder do |xml|
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
end

get '/' do
  @posts = Post.filter(:published => true).order(:published_at.desc).paginate(params[:page] || 1, 10)
  erb :posts
end

get '/tags' do
  @tags = Tag.all
  erb :tags
end

get %r{\A\/tags\/([\w]+)\z} do
  tag = Tag.filter(:name => params[:captures][0].downcase).first
  @posts = []
  
  if tag
    taggings = Tagging.filter(:tag_id => tag.id).select(:post_id)
    @posts = Post.filter({:published => true} & {:id => taggings}).order(:published_at.desc)
    erb :archive
  else
    halt 404, "Tag not found"
  end

end

get %r{\A\/([0-9]{4})\/?\z} do
  start_date = DateTime.parse("#{params[:captures][0]}/1/1")
  end_date = DateTime.parse("#{params[:captures][0]}/12/31")
  @posts = Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  erb :archive
end

get %r{\A\/([0-9]{4})\/([0-9]{2})\/?\z} do
  start_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/1")
  end_date = DateTime.parse("#{params[:captures][0]}/#{params[:captures][1]}/#{get_end_day(params[:captures][1].to_i)}")
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
  @comment.post = @post
  @comment.save
  
  redirect_to "#{@post.permalink}"
end

get '*' do
  @post = Post.filter('published = ? AND permalink = ?', true, params[:splat][0]).first
  halt 404, "Post not found" unless @post
  erb :post
end