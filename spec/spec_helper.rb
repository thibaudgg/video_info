require 'rspec'
require 'video_info'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.default_cassette_options = { :record => :new_episodes }
  config.hook_into :fakeweb
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
  config.color_enabled = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
