require 'rubygems'
require 'sinatra'

%w[sequel maruku splam splam/rule splam/rules].each do |prereq|
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/#{prereq}/lib"
  require prereq
end

configure :test do
  db = Sequel::DATABASES.first || Sequel.connect('sqlite:/')
  
  require 'sequel/extensions/migration'
  Sequel::Migrator.apply(db, 'db/migrations', 0, nil)
  Sequel::Migrator.apply(db, 'db/migrations')
  db[:blogs].insert(:title =>'my test blog', :tagline => 'testing 1,2,3', :theme => 'default', :domain => 'http://test.com')
end

configure :production, :development do
  Sequel.connect('sqlite://db/blog.db')
end

configure do

  %w[blog post comment tag tagging user].each do |model|
    require "models/#{model}"
  end
  
  if Blog.default
    set :public, 'themes/' + Blog.default.theme + '/public'
    set :views, 'themes/' + Blog.default.theme + '/views'
  end
  
  use Rack::Session::Cookie,  :key => 'rack.session',
                              :domain => Blog.default.domain,
                              :path => '/',
                              :secret => Blog.default.secret
                              
  require "sequel/extensions/pagination"
end

layout 'layout'
load 'routes.rb'