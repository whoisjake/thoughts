require File.dirname(__FILE__) + '/../test_helper'

describe Tag do
  
  before do
    @tag = Tag.new
    Tag.delete
  end

end