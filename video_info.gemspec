# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'video_info/version'

Gem::Specification.new do |s|
  s.name         = 'video_info'
  s.version      = VideoInfo::VERSION
  s.license      = 'MIT'

  s.author       = 'Thibaud Guillaume-Gentil'
  s.email        = 'thibaud@thibaud.gg'
  s.homepage     = 'https://rubygems.org/gems/video_info'
  s.summary      = 'Dailymotion, Vimeo and YouTube info parser.'
  s.description  = 'Get video info from Dailymotion, Vimeo and YouTube url.'

  s.files        = `git ls-files`.split($/).reject { |x| x.match?(%r{^spec/}) }
  s.require_path = 'lib'

  s.required_ruby_version = '>= 2.5.0'

  s.add_dependency 'iso8601', '~> 0.9.1'
  s.add_dependency 'oga', '~> 3.0'
  s.add_dependency 'net_http_timeout_errors', '~> 0.3.0'

  s.add_development_dependency 'bundler', '>= 1.3.5'
  s.add_development_dependency 'rake', '>= 12.3.3'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-its', '~> 1.2'
  s.add_development_dependency 'rubocop', '~> 0.37'
  s.add_development_dependency 'vcr', '~> 3.0.3'
  s.add_development_dependency 'webmock', '~> 3.7'
end
