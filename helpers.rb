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
end

not_found do
  erb :four_oh_four
end

helpers do
  
  def get_end_day(month)
    [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]
  end
  
  def request_for_static?
    /(\/images|\/javascripts|\/stylesheets)/.match(request.path_info)
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
