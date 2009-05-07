require 'rubygems'
require 'sinatra'
require File.dirname(__FILE__) + '/../thoughts'

require 'spec'
require 'spec/interop/test'
require 'sinatra/test'

set :environment, :test

require 'sequel/extensions/migration'
db = Sequel.sqlite
Sequel::Migrator.apply(db, File.dirname(__FILE__) + '/../db/migrations', 0, nil)
Sequel::Migrator.apply(db, File.dirname(__FILE__) + '/../db/migrations')