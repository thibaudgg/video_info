# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{video_info}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thibaud Guillaume-Gentil"]
  s.date = %q{2008-11-27}
  s.description = %q{Get video info from youtube and vimeo url.}
  s.email = %q{guillaumegentil@gmail.com}
  s.extra_rdoc_files = ["lib/provider/vimeo.rb", "lib/provider/youtube.rb", "lib/video_info.rb", "README.rdoc"]
  s.files = ["init.rb", "lib/provider/vimeo.rb", "lib/provider/youtube.rb", "lib/video_info.rb", "Rakefile", "README.rdoc", "Manifest", "video_info.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{ttp://github.com/guillaumegentil/video_info}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Video_info", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{video_info}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Get video info from youtube and vimeo url.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hpricot>, [">= 0.6"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6"])
  end
end
