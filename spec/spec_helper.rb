require 'rubygems'
require 'rspec'
require 'video_info'
require 'video_info/version'
require 'vcr'

VCR.config do |config|
  config.stub_with :webmock
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
  config.color_enabled = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end