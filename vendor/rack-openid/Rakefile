require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'

# load gemspec like github's gem builder to surface any SAFE issues.
Thread.new {
  require 'rubygems/specification'
  $spec = eval("$SAFE=3\n#{File.read('rack-openid.gemspec')}")
}.join

Rake::GemPackageTask.new($spec) do |package|
  package.gem_spec = $spec
end

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc 'Publish gem to RubyForge'
task :release => [ :package ] do
  group_id     = $spec.rubyforge_project
  package_id   = $spec.name
  release_name = $spec.version
  userfile     = File.expand_path("pkg/#{$spec.name}-#{$spec.version}.gem")

  sh "rubyforge add_release #{group_id} #{package_id} #{release_name} #{userfile}"
end
