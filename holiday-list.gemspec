# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'holiday/list/version'

Gem::Specification.new do |spec|
  spec.name          = "holiday-list"
  spec.version       = Holiday::List::VERSION
  spec.authors       = ["Ben Hicks"]
  spec.email         = ["benkhicks@gmail.com"]
  spec.description   = %q{Holiday List}
  spec.summary       = %q{Connects to google calendar and retrieves holidays}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "activerecord"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock", "~> 1.15.0"
  spec.add_development_dependency "timecop"
end
