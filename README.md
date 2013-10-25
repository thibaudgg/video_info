# VideoInfo

[![Gem Version](https://badge.fury.io/rb/video_info.png)](http://badge.fury.io/rb/video_info) [![Build Status](https://travis-ci.org/thibaudgg/video_info.png?branch=master)](https://travis-ci.org/thibaudgg/video_info) [![Dependency Status](https://gemnasium.com/thibaudgg/video_info.png)](https://gemnasium.com/thibaudgg/video_info) [![Code Climate](https://codeclimate.com/github/thibaudgg/video_info.png)](https://codeclimate.com/github/thibaudgg/video_info) [![Coverage Status](https://coveralls.io/repos/thibaudgg/video_info/badge.png?branch=master)](https://coveralls.io/r/thibaudgg/video_info)

Simple Ruby Gem to get video info from YouTube, Vimeo and VK url.

Tested against Ruby 1.9.3, 2.0.0 and the latest versions of JRuby & Rubinius.

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
# video.duration         => 175 (in seconds)
# video.date             => Sat Apr 12 22:25:35 UTC 2008
# video.thumbnail_small  => "http://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg"
# video.thumbnail_medium => "http://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg"
# video.thumbnail_large  => "http://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg"
# video.embed_url        => "http://www.youtube.com/embed/mZqGqE0D0n4"
# video.embed_code       => "'<iframe src="http://www.youtube.com/embed/mZqGqE0D0n4" frameborder="0" allowfullscreen="allowfullscreen"></iframe>'"

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
# video.thumbnail_small  => "http://b.vimeocdn.com/ts/343/731/34373130_100.jpg"
# video.thumbnail_medium => "http://b.vimeocdn.com/ts/343/731/34373130_200.jpg"
# video.thumbnail_large  => "http://b.vimeocdn.com/ts/343/731/34373130_640.jpg"
# video.embed_url        => "http://player.vimeo.com/video/898029"
# video.embed_code       => "'<iframe src="http://player.vimeo.com/video/898029?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=0" frameborder="0"></iframe>'"
```

Options
-------

``` ruby
video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", "User-Agent" => "My YouTube Mashup Robot/1.0")
video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", "Referer"    => "http://my-youtube-mashup.com/")
video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", "Referer"    => "http://my-youtube-mashup.com/",
                                                                    "User-Agent" => "My YouTube Mashup Robot/1.0")
```
You can also use **symbols** instead of strings (any non-word (`/[^a-z]/i`) character would be converted to hyphen).

``` ruby
video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4", :referer    => "http://my-youtube-mashup.com/",
                                                                      user_agent: "My YouTube Mashup Robot/1.0")
```

User-Agent when empty defaults to "VideoInfo/VERSION" - where version is current VideoInfo version, e.g. **"VideoInfo/0.2.7"**.

It supports all openURI header fields (options), for more information see: [openURI DOCS](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/open-uri/rdoc/OpenURI.html)

You can also include an `iframe_attributes` or `url_attributes` hash to the `embed_code` method to include arbitrary attributes in the iframe embed code or as additional URL params:

``` ruby
VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4").embed_code(iframe_attributes: { width: 800, height: 600, "data-key" => "value" })
=> '<iframe src="http://www.youtube.com/embed/mZqGqE0D0n4" frameborder="0" allowfullscreen="allowfullscreen" width="800" height="600" data-key="value"></iframe>

'VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4").embed_code(url_attributes: { autoplay: 1 })
=> '<iframe src="http://www.youtube.com/embed/mZqGqE0D0n4?autoplay=1" frameborder="0" allowfullscreen="allowfullscreen"></iframe>'
```

Author
------

[Thibaud Guillaume-Gentil](https://github.com/thibaudgg) ([@thibaudgg](https://twitter.com/thibaudgg))

Contributors
------------

[https://github.com/thibaudgg/video_info/graphs/contributors](https://github.com/thibaudgg/video_info/graphs/contributors)

