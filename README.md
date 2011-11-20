VideoInfo [![Build Status](https://secure.travis-ci.org/thibaudgg/video_info.png?branch=master)](http://travis-ci.org/thibaudgg/video_info)
=========
  
Small Ruby Gem to get video info from youtube and vimeo url.
Tested against Ruby 1.8.7, 1.9.2, REE and the latest versions of JRuby & Rubinius.
  
Install
--------

``` bash
  gem install video_info
```
  
Usage
-----
  
``` ruby
  video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4")
  
  # video.video_id         => "mZqGqE0D0n4"
  # video.provider         => "YouTube"
  # video.title            => "Cherry Bloom - King Of The Knife"
  # video.description      => "The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net"
  # video.keywords         => "alternative, bloom, cherry, clip, drum, guitar, king, knife, of, Paris-Forum, rock, the, tremplin"
  # video.duration         => 175 (in seconds)
  # video.date             => Sat Apr 12 22:25:35 UTC 2008
  # video.thumbnail_small  => "http://i.ytimg.com/vi/mZqGqE0D0n4/2.jpg"
  # video.thumbnail_large  => "http://i.ytimg.com/vi/mZqGqE0D0n4/0.jpg"
  
  video = VideoInfo.new("http://vimeo.com/898029")
  
  # video.video_id         => "898029"
  # video.provider         => "Vimeo"
  # video.title            => "Cherry Bloom - King Of The Knife"
  # video.description      => "The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net"
  # video.keywords         => "alternative, bloom, cherry, clip, drum, guitar, king, knife, of, Paris-Forum, rock, the, tremplin"
  # video.duration         => 175 (in seconds)
  # video.date             => Mon Apr 14 13:10:39 +0200 2008
  # video.width            => 640
  # video.height           => 360
  # video.thumbnail_small  => "http://ts.vimeo.com.s3.amazonaws.com/343/731/34373130_100.jpg"
  # video.thumbnail_large  => "http://ts.vimeo.com.s3.amazonaws.com/343/731/34373130_640.jpg"
  
  video = VideoInfo.new("http://badurl.com/898029")
  
  # video.valid? => false
```

Options
-------

``` ruby
  video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", "User-Agent" => "My Youtube Mashup Robot/1.0")
  video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", "Referer"    => "http://my-youtube-mashup.com/")
  video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", "Referer"    => "http://my-youtube-mashup.com/",
                                                                      "User-Agent" => "My Youtube Mashup Robot/1.0")
```
You can also use **symbols** instead of strings (any non-word (`/[^a-z]/i`) character would be converted to hyphen).

``` ruby
  video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", :referer    => "http://my-youtube-mashup.com/",
                                                                      :user_agent => "My Youtube Mashup Robot/1.0")
```

User-Agent when empty defaults to "VideoInfo/VERSION" - where version is current VideoInfo version, e.g. **"VideoInfo/0.2.7"**.

It supports all openURI header fields (options), for more information see: [openURI DOCS](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/open-uri/rdoc/OpenURI.html)


Author
------

[Thibaud Guillaume-Gentil](https://github.com/thibaudgg) ([@thibaudgg](http://twitter.com/thibaudgg))
