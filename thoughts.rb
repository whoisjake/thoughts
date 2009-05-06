require 'rubygems'
require 'sinatra'

configure do
  
  %w[sequel maruku splam splam/rule splam/rules].each do |prereq|
    $LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/#{prereq}/lib"
    require prereq
  end
  
  Sequel.sqlite('db/blog.db')
  
  %w[blog post comment tag tagging user].each do |model|
    require "models/#{model}"
  end
  
  set :public, File.dirname(__FILE__) + '/themes/' + Blog.default.theme + '/public'
  set :views, File.dirname(__FILE__) + '/themes/' + Blog.default.theme + '/views'

end

layout 'layout'
load 'routes.rb'