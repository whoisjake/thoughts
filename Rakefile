
namespace :db do
  
  desc "Creates the default database" 
  task :init do
    
    # Ensure that sqlite3 file is there
    unless File.exist?('db/blog.db')
      require 'sqlite3'
      db = SQLite3::Database.new('db/blog.db')
      db.close
    end
     
    db = load_sequel
    Sequel::Migrator.apply(db, 'db/migrations')
  end
  
  desc "Creates a default user"
  task :create_user do
    db = load_sequel
    
    $LOAD_PATH.unshift File.dirname(__FILE__) + "/models/"
    require 'user'
    require 'blog'
    
    user = User.new
    
    print "login: "
    user.username = STDIN.gets.chomp
    
    print "password: "
    user.password = STDIN.gets.chomp
    
    print "email: "
    user.email = STDIN.gets.chomp
    
    user.blog = Blog.default
    
    if user.save
      puts "User created."
    else
      puts "User not created."
    end
  end
  
  desc "[WARNING] Clears the database. Drops all tables and data."
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

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*.rb']
end

def load_sequel
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/sequel/lib"
  require 'sequel'
  require 'sequel/extensions/migration'
  Sequel.sqlite('db/blog.db')
end