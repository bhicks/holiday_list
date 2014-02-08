require "bundler/gem_tasks"
require "rspec/core"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test    => :spec

task :console do
  require 'irb'
  require 'irb/completion'
  require 'holiday_list'
  ARGV.clear
  IRB.start
end
