require File.dirname(__FILE__) + '/../test_helper'

describe Comment do
  
  before do
    @comment = Comment.new
    Comment.delete
  end

end