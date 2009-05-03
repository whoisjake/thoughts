require File.dirname(__FILE__) + '/../test_helper'

describe Post do
  
  before do
    @post = Post.new
    Post.delete
  end

end