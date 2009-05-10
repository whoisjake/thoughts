require 'rubygems'
require 'sinatra'
require File.dirname(__FILE__) + '/../thoughts'

require 'spec'
require 'spec/interop/test'
require 'sinatra/test'

set :environment, :test

require 'sequel/extensions/migration'

# Hack for tests to ensure that the models are only using the in memory database
Sequel::DATABASES.each do |db|
  db.disconnect
end
Sequel::DATABASES.clear

db = Sequel.connect('sqlite:/')

Sequel::Migrator.apply(db, File.dirname(__FILE__) + '/../db/migrations', 0, nil)
Sequel::Migrator.apply(db, File.dirname(__FILE__) + '/../db/migrations')