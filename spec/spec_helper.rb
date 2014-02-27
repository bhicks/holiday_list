require 'holiday_list'
require 'vcr'
require 'timecop'
require 'active_support/core_ext/time/calculations'
require 'dotenv'
require 'pry'

VCR.configure do |config|
  config.cassette_library_dir = File.join %w{ spec vcr cassettes }
  config.hook_into :webmock

  if ENV['RERECORD'].present?
    Dotenv.load
    config.default_cassette_options = { record: :all }
  end
end
