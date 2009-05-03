namespace :db do
  
  desc "Creates the default database" 
  task :init do
    db = load_sequel
    Sequel::Migrator.apply(db, 'db/migrations')
  end
  
  task :clear do
    db = load_sequel
    print "Are you sure you want to clear? [Y]: "
    answer = STDIN.gets.chomp
    if answer.downcase == "y"
      puts "Database clearing..."
      Sequel::Migrator.apply(db, 'db/migrations', 0, nil)
      puts "Database cleared!"
    else
      puts "Database not cleared!"
    end
  end
  
  desc "Updates the database"
  task :update do
    db = load_sequel
    Sequel::Migrator.apply(db, 'db/migrations')
  end
  
end

def load_sequel
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/sequel/lib"
  require 'sequel'
  require 'sequel/extensions/migration'
  Sequel.sqlite('db/blog.db')
end