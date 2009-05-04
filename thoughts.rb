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
  
end

layout 'layout'

class Fixnum
  def pad
    self.to_s.length == 1 ? "0#{self}" : self.to_s
  end
end


get '/' do
  @blog = Blog.default
  @posts = Post.filter(:published).order(:created_at.desc).limit(10)
  erb :posts
end

get '/admin' do
end

get '/admin/posts' do
end

get '/admin/comments' do
end

get %r{\/[0-9]{4}} do
end

get %r{\/[0-9]{4}\/[0-9]{2}} do
end

get %r{\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}} do
end

get '/*' do
end