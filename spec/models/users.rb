require File.dirname(__FILE__) + '/../test_helper'

describe User do
  
  before do
    @user = User.new
    User.delete
  end

end