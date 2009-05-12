require 'rubygems'
require 'sinatra'

set :environment, :test

require File.dirname(__FILE__) + '/../thoughts'

require 'spec'
require 'spec/interop/test'
require 'sinatra/test'

Spec::Runner.configure do |config|
  
  config.after(:each) do
    db = Sequel::DATABASES.first
    db.tables.each do |table|
      db << "DELETE FROM #{table.to_s};"
    end
  end

end