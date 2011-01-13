# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "video_info/version"

Gem::Specification.new do |s|
  s.name        = "video_info"
  s.version     = VideoInfoVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Thibaud Guillaume-Gentil']
  s.email       = ['thibaud@thibaud.me']
  s.homepage    = 'http://rubygems.org/gems/video_info'
  s.summary     = 'Vimeo & Youtube parser'
  s.description = 'Get video info from youtube and vimeo url.'

  s.rubyforge_project = "video_info"

  s.add_development_dependency 'bundler',     '~> 1.0.7'
  s.add_development_dependency 'rspec',       '~> 2.4.0'
  s.add_development_dependency 'guard-rspec', '~> 0.1.9'
  s.add_development_dependency 'vcr',         '~> 1.5.0'
  s.add_development_dependency 'webmock',     '~> 1.6.2'

  s.add_dependency 'hpricot', '~> 0.8.3'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_paths = ["lib"]
end