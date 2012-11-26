# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "video_info/version"

Gem::Specification.new do |s|
  s.name        = "video_info"
  s.version     = VideoInfo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Thibaud Guillaume-Gentil']
  s.email       = ['thibaud@thibaud.me']
  s.homepage    = 'http://rubygems.org/gems/video_info'
  s.summary     = 'Vimeo & Youtube parser'
  s.description = 'Get video info from youtube and vimeo url.'

  s.rubyforge_project = "video_info"

  s.add_dependency 'multi_json'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'vcr'

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_paths = ["lib"]
end
