# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'video_info/version'

Gem::Specification.new do |s|
  s.name         = 'video_info'
  s.version      = VideoInfo::VERSION
  s.license      = 'MIT'

  s.author       = 'Mahdiar Golchin'
  s.email        = 'thibaud@thibaud.gg'
  s.homepage     = 'https://rubygems.org/gems/video_info'
  s.summary      = 'Aparat,Dailymotion, Vimeo, VK and YouTube info parser.'
  s.description  = 'Get video info from Aparat,Dailymotion, Vimeo, VK and YouTube url.'

  s.files        = `git ls-files`.split($/)
  s.test_files   = s.files.grep(%r{^spec/})
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'addressable', '~> 2.3'
  s.add_dependency 'multi_json', '~> 1.11'
  s.add_dependency 'htmlentities', '~> 4.3'
  s.add_dependency 'iso8601', '~> 0.9'
  s.add_dependency 'oga', '~> 1.3'
  s.add_dependency 'open_uri_redirections', '~> 0.2'
  s.add_dependency 'net_http_timeout_errors', '~> 0.3.0'

  s.add_development_dependency 'bundler', '>= 1.3.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
