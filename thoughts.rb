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