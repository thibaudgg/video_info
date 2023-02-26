require "simplecov"
require "simplecov_json_formatter"

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
])
SimpleCov.start

require "rspec"
require "rspec/its"
require "video_info"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.default_cassette_options = {
    record: :new_episodes,
    re_record_interval: 28 * 24 * 60 * 60
  }

  # When re-recording VCR cassetes, the necessary keys can be set as env variables:
  # YOUTUBE_API_KEY=<valid_youtube_key> VIMEO_ACCESS_TOKEN=<valid_vimeo_key> bundle exec rspec
  config.filter_sensitive_data("youtube_api_key_123") { ENV["YOUTUBE_API_KEY"] } if ENV["YOUTUBE_API_KEY"]
  config.filter_sensitive_data("vimeo_access_token") { ENV["VIMEO_ACCESS_TOKEN"] } if ENV["VIMEO_ACCESS_TOKEN"]

  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
