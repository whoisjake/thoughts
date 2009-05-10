desc "Creates a default user"
task :create_user do
  db = load_sequel
  
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/models/"
  require 'user'
  require 'blog'
  
  user = User.new
  
  print "name: "
  user.name = STDIN.gets.chomp
  
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

desc "Creates a default blog"
task :create_blog do
  db = load_sequel
  
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/models/"
  require 'blog'
  
  print "Do you want to clear out previously created blogs?"
  print "If not, the last created blog will be the default. [N]: "
  answer = STDIN.gets.chomp
  
  if answer.downcase == "y"
    puts "Blogs clearing..."
    Blog.delete
    puts "Blogs cleared!"
  end
  
  blog = Blog.new
  
  print "domain: "
  blog.domain = STDIN.gets.chomp
  
  print "title: "
  blog.title = STDIN.gets.chomp
  
  print "tagline: "
  blog.tagline = STDIN.gets.chomp
  
  print "permalink [/:year/:month/:day/:title]: "
  blog.permalink = STDIN.gets.chomp
  
  print "theme [default]: "
  blog.theme = STDIN.gets.chomp
  
  print "external rss feed: "
  blog.external_rss_feed = STDIN.gets.chomp
  
  if blog.save
    puts "Blog created."
  else
    puts "Blog not created."
  end
end

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
  
  desc "[WARNING] Clears the database. Drops all tables and data."
  task :clear do
    db = load_sequel
    print "Are you sure you want to clear? [N]: "
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