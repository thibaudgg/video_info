source "http://rubygems.org"

# Specify your gem's dependencies in video_info.gemspec
gemspec

gem 'guard',              :git => "git://github.com/guard/guard.git"

require 'rbconfig'

if Config::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '>= 0.3.9'
  gem 'growl',      '~> 1.0.3'
end
if Config::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '>= 0.5.1'
  gem 'libnotify',  '~> 0.1.3'
end