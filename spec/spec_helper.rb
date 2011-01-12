require 'rubygems'
require 'rspec'
require 'video_info'
require 'vcr'

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
    
  config.color_enabled = true
  
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end