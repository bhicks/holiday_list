require 'holiday_list'
require 'vcr'
require 'timecop'
require 'active_support/core_ext/time/calculations'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr/cassettes' # root.join('spec', 'vcr')
  config.hook_into :webmock
end
