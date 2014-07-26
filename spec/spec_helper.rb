require 'rspec'
require 'rspec/its'
require 'video_info'
require 'vcr'

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.default_cassette_options = {
    record: :new_episodes,
    re_record_interval: 7 * 24 * 60 * 60
  }
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
