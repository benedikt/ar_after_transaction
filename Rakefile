require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--color']
end

begin
  require 'jeweler'
  project_name = 'ar_after_transaction'
  Jeweler::Tasks.new do |gem|
    gem.name = project_name
    gem.summary = "Execute irreversible actions only when transactions are not rolled back"
    gem.email = "grosser.michael@gmail.com"
    gem.homepage = "http://github.com/grosser/#{project_name}"
    gem.authors = ["Michael Grosser"]
    gem.add_dependency ['activerecord']
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
