require "bundler/gem_tasks"
require "rspec/core"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test    => :spec

desc 'Launch irb with holiday_list required'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'holiday_list'
  ARGV.clear
  IRB.start
end

# TODO: add task to clean vcr cassettes
#
# TODO: add task to automatically scrub GOOGLE_ACCESS_KEY from VCR cassettes,
# replacing with the convention used in the tests, A_GOOD_KEY
#
# TODO: add git pre-commit hook to prevent users from checking in
# GOOGLE_ACCESS_KEY in VCR cassettes
#
# TODO: automate switching between dotenv and VCR cassettes.
