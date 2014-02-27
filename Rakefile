require "bundler/gem_tasks"
require "rspec/core"
require "rspec/core/rake_task"
require "dotenv"

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

namespace :spec do
  desc 'Run RSpec, re-recording VCR cassettes'
  task :rerecord do
    Dotenv.load

    ENV['RERECORD'] = 'true'
    Rake::Task['spec'].execute
    Rake::Task['spec:scrub'].execute
  end

  desc 'Scrub access key tokens'
  task :scrub do
    Dotenv.load

    FileList.new('spec/vcr/cassettes/*.yml').each do |file|
      next unless key = ENV['GOOGLE_ACCESS_KEY']

      modified_file = File.open(file).read.gsub(/#{key}/, 'A_GOOD_KEY')

      File.open(file, 'w') do |out|
        out << modified_file
      end
    end
  end
end

# TODO: add git pre-commit hook to prevent users from checking in
# GOOGLE_ACCESS_KEY in VCR cassettes
