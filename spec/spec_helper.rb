require 'holiday/list'
require 'vcr'
require 'timecop'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr/cassettes' # root.join('spec', 'vcr')
  config.hook_into :webmock
end
