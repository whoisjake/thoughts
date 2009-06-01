before do
  @blog = Blog.default unless request_for_static?
  
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
  options.logger.info "PARAMS: #{request.params.inspect}" if options.logger && !request_for_static?
  options.logger.info "SESSION: #{session.inspect}" if options.logger && !request_for_static?
  options.logger.info "MOBILE: #{mobile?}" if options.logger && !request_for_static?
end

not_found do
  erb :four_oh_four
end

helpers do
  
  def mobile?
    /(iPhone|iPod|BlackBerry|Android|Windows CE|Palm)/.match(request.env["HTTP_USER_AGENT"])
  end
  
  def get_last_day(month)
    [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]
  end
  
  def request_for_static?
    /(\/images|\/javascripts|\/stylesheets)/.match(request.path_info)
  end
  
  def capture_and_validate_dates(date_input)
    begin
      if date_input[2]
        start_date = DateTime.parse("#{date_input[0]}/#{date_input[1]}/#{date_input[2]}") 
        end_date = DateTime.parse("#{date_input[0]}/#{date_input[1]}/#{date_input[2]}")
      elsif date_input [1]
        start_date = DateTime.parse("#{date_input[0]}/#{date_input[1]}/1")
        end_date = DateTime.parse("#{date_input[0]}/#{date_input[1]}/#{get_last_day(date_input[1].to_i)}")
      else
        start_date = DateTime.parse("#{date_input[0]}/1/1")
        end_date = DateTime.parse("#{date_input[0]}/12/31")
      end
    rescue ArgumentError
      now = DateTime.now
      return [DateTime.parse("#{now.year}/#{now.month}/1"),DateTime.parse("#{now.year}/#{now.month}/#{get_last_day(now.month)}")]
    end
    
    [start_date, end_date]
  end
  
  def filter_posts_by_date(date_input)
    start_date, end_date = capture_and_validate_dates(date_input)
    Post.filter({:published => true} & {:published_at => (start_date..end_date)})
  end
  
  def authenticate
    # check session or redirect to login
    unless session["identity_url"] && session["authenticated"] && @user = User.find_by_openid(session["identity_url"])
      redirect_to "/admin/login"
    end
  end
  
  def redirect_to(url)
    redirect url
  end
  
  def rss_feed(blog)
    blog.external_rss_feed || '/rss'
  end
  
  def comments_feed(blog)
    '/comments/rss'
  end
  
  include Rack::Utils
  alias_method :h, :escape_html
  
end
