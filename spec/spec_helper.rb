require 'rubygems'
require 'sinatra'

set :environment, :test

require File.dirname(__FILE__) + '/../thoughts'

require 'spec'
require 'spec/interop/test'
require 'sinatra/test'

require 'sequel/extensions/migration'

