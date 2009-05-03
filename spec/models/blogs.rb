require File.dirname(__FILE__) + '/../test_helper'

describe Blog do
  
  before(:each) do
    Blog.delete
    @blog = Blog.new
  end
  
  it "can set values." do
    @blog.title = "My test blog title"
    @blog.tagline = "My test blog tagline"
  end
  
  it "can be saved." do
    @blog.title = "My awesome saving blog"
    @blog.tagline = "My awesome saving blog tagline"
    @blog.save
  end
  
  it "can find the default blog." do
    @blog.title = "Default Blog"
    @blog.tagline = "Default Blog Tagline"
    @blog.save
    
    Blog.should_receive(:first).and_return(@blog)
    Blog.default.should == @blog
  end

end