#require 'rubygems'
#require 'spec'

%w[sequel maruku splam splam/rule splam/rules].each do |prereq|
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/../../vendor/#{prereq}/lib"
  require prereq
end

require 'sequel/extensions/migration'
db = Sequel.sqlite
Sequel::Migrator.apply(db, File.dirname(__FILE__) + '/../../db/migrations', 0, nil)
Sequel::Migrator.apply(db, File.dirname(__FILE__) + '/../../db/migrations')

$LOAD_PATH.unshift File.dirname(__FILE__) + "/../../models"
%w[blog post comment tag tagging user].each do |model|
  require model
end

class Fixnum
  def pad
    self.to_s.length == 1 ? "0#{self}" : self.to_s
  end
end