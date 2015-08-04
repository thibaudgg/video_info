# VideoInfo

[![Gem Version](https://badge.fury.io/rb/video_info.svg)](http://badge.fury.io/rb/video_info) [![Build Status](https://travis-ci.org/thibaudgg/video_info.svg?branch=master)](https://travis-ci.org/thibaudgg/video_info) [![Dependency Status](https://gemnasium.com/thibaudgg/video_info.svg)](https://gemnasium.com/thibaudgg/video_info) [![Code Climate](https://codeclimate.com/github/thibaudgg/video_info.svg)](https://codeclimate.com/github/thibaudgg/video_info) [![Coverage Status](https://coveralls.io/repos/thibaudgg/video_info/badge.svg?branch=master)](https://coveralls.io/r/thibaudgg/video_info)

Simple Ruby Gem to get video info from Dailymotion, VK, Vimeo (with playlist), Wistia and YouTube (with playlist).

Tested against Ruby 2.2.0 and the latest versions of JRuby & Rubinius.

Install
--------

``` bash
gem install video_info
```

Usage
-----

## Note for YouTube usage!
Youtube recently updated their API to require an API key.

To get around this, a scraper was implemented. However, the scraper can only get the date the video was posted, while the API is able to get the date and the exact time the video was posted.

You may also wish to use the API to protect against potential HTML changes that could break the scraper.

To get an API key, [follow the instructions here](https://developers.google.com/youtube/registering_an_application)

To set the API key, do the following:
``` ruby
VideoInfo.provider_api_keys = { youtube: 'YOUR_API_KEY' }
```


``` ruby
video = VideoInfo.new('http://www.dailymotion.com/video/x7lni3')
# video.available?       => true
# video.video_id         => 'x7lni3'
# video.provider         => 'Dailymotion'
# video.title            => 'Mario Kart (Rémi Gaillard)'
# video.description      => 'Super Rémi Kart est un jeu vidéo de course développé et édité par N'Importe Quoi TV.'
# video.duration         => 136 (in seconds)
# video.date             => Mon Mar 03 16:29:31 UTC 2008
# video.thumbnail_small  => 'http://s2.dmcdn.net/BgWxI/x60-kbf.jpg'
# video.thumbnail_medium => 'http://s2.dmcdn.net/BgWxI/x240-b83.jpg'
# video.thumbnail_large  => 'http://s2.dmcdn.net/BgWxI/x720-YcV.jpg'
# video.embed_url        => 'http://www.dailymotion.com/embed/video/x7lni3'
# video.embed_code       => "<iframe src='//www.dailymotion.com/embed/video/x7lni3' frameborder='0' allowfullscreen='allowfullscreen'></iframe>"

video = VideoInfo.new("http://vimeo.com/898029")
# video.available?       => true
# video.video_id         => '898029'
# video.provider         => 'Vimeo'
# video.title            => 'Cherry Bloom - King Of The Knife'
# video.description      => 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net'
# video.keywords         => 'alternative, bloom, cherry, clip, drum, guitar, king, knife, of, Paris-Forum, rock, the, tremplin'
# video.duration         => 175 (in seconds)
# video.date             => Mon Apr 14 13:10:39 +0200 2008
# video.width            => 640
# video.height           => 360
# video.thumbnail_small  => 'http://b.vimeocdn.com/ts/343/731/34373130_100.jpg'
# video.thumbnail_medium => 'http://b.vimeocdn.com/ts/343/731/34373130_200.jpg'
# video.thumbnail_large  => 'http://b.vimeocdn.com/ts/343/731/34373130_640.jpg'
# video.embed_url        => 'http://player.vimeo.com/video/898029'
# video.embed_code       => "<iframe src='//player.vimeo.com/video/898029?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=0' frameborder='0'></iframe>"

video = VideoInfo.new("http://fast.wistia.com/embed/medias/pxonqr42is")
# video.available?       => true
# video.provider         => 'Wistia'
# video.video_id         => 'pxonqr42is'
# video.title            => 'Understanding Analytics'
# video.duration         => 250 (in seconds)
# video.width            => 960
# video.height           => 568
# video.thumbnail_small  => 'https://embed-ssl.wistia.com/deliveries/0fccbdc60ade35723f79f1c002bc61b135b610fa.jpg?image_crop_resized=960x540'
# video.thumbnail_medium => 'https://embed-ssl.wistia.com/deliveries/0fccbdc60ade35723f79f1c002bc61b135b610fa.jpg?image_crop_resized=960x540'
# video.thumbnail_large  => 'https://embed-ssl.wistia.com/deliveries/0fccbdc60ade35723f79f1c002bc61b135b610fa.jpg?image_crop_resized=960x540'
# video.embed_url        => '//fast.wistia.net/embed/iframe/pxonqr42is'
# video.embed_code       => "<iframe src='//fast.wistia.net/embed/iframe/pxonqr42is' frameborder='0'></iframe>"

video = VideoInfo.new("http://www.youtube.com/watch?v=mZqGqE0D0n4")
# video.available?       => true
# video.video_id         => 'mZqGqE0D0n4'
# video.provider         => 'YouTube'
# video.title            => 'Cherry Bloom - King Of The Knife'
# video.description      => 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net'
# video.duration         => 175 (in seconds)
# video.date             => Sat Apr 12 22:25:35 UTC 2008
# video.thumbnail_small  => 'http://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg'
# video.thumbnail_medium => 'http://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg'
# video.thumbnail_large  => 'http://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg'
# video.embed_url        => 'http://www.youtube.com/embed/mZqGqE0D0n4'
# video.embed_code       => "<iframe src='//www.youtube.com/embed/mZqGqE0D0n4' frameborder='0' allowfullscreen='allowfullscreen'></iframe>"

playlist = VideoInfo.new("http://www.youtube.com/playlist?p=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr")
# playlist.available?          => true
# playlist.playlist_id         => 'PL9hW1uS6HUftLdHI6RIsaf'
# playlist.provider            => 'YouTube'
# playlist.title               => 'YouTube Policy and Copyright'
# playlist.thumbnail_small     => 'http://i.ytimg.com/vi/8b0aEoxqqC0/default.jpg'
# playlist.thumbnail_medium    => 'http://i.ytimg.com/vi/8b0aEoxqqC0/mqdefault.jpg'
# playlist.thumbnail_large     => 'http://i.ytimg.com/vi/8b0aEoxqqC0/hqdefault.jpg'
# playlist.embed_url           => 'http://www.youtube.com/embed/videoseries?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr'
# playlist.embed_code          => "<iframe src='//www.youtube.com/embed/videoseries?list=PL9hW1uS6HUftLdHI6RIsaf-iXTm09qnEr' frameborder='0' allowfullscreen='allowfullscreen'></iframe>"
# playlist.videos              => [VideoInfo.new('http://www.youtube.com/watch?v=_Bt3-WsHfB0'), VideoInfo.new('http://www.youtube.com/watch?v=9g2U12SsRns'), VideoInfo.new('http://www.youtube.com/watch?v=8b0aEoxqqC0'), VideoInfo.new('http://www.youtube.com/watch?v=6c3mHikRz0I'), VideoInfo.new('http://www.youtube.com/watch?v=OQVHWsTHcoc')]

playlist = VideoInfo.new("http://vimeo.com/album/2755718")
# playlist.available?          => true
# playlist.playlist_id         => '2755718'
# playlist.provider            => 'Vimeo'
# playlist.title               => 'The Century Of Self'
# playlist.thumbnail_small     => 'http://b.vimeocdn.com/ts/443/595/443595474_100.jpg'
# playlist.thumbnail_medium    => 'http://b.vimeocdn.com/ts/443/595/443595474_200.jpg'
# playlist.thumbnail_large     => 'http://b.vimeocdn.com/ts/443/595/443595474_640.jpg'
# playlist.embed_url           => 'player.vimeo.com/hubnut/album/2755718'
# playlist.embed_code          => "<iframe src='//player.vimeo.com/hubnut/album/2755718?autoplay=0&byline=0&portrait=0&title=0' frameborder='0'></iframe>"
# playlist.videos              => [VideoInfo.new('http://vimeo.com/67977038'), VideoInfo.new('http://vimeo.com/68843810'), VideoInfo.new('http://vimeo.com/69949597'), VideoInfo.new('http://vimeo.com/70388245')]
```

Options
-------

``` ruby
video = VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4', 'User-Agent' => 'My YouTube Mashup Robot/1.0')
video = VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4', 'Referer'    => 'http://my-youtube-mashup.com/')
video = VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4', 'Referer'    => 'http://my-youtube-mashup.com/',
                                                                    'User-Agent' => 'My YouTube Mashup Robot/1.0')
```
You can also use **symbols** instead of strings (any non-word (`/[^a-z]/i`) character would be converted to hyphen).

``` ruby
video = VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4', referer: 'http://my-youtube-mashup.com/',
                                                                    user_agent: 'My YouTube Mashup Robot/1.0')
```

User-Agent when empty defaults to "VideoInfo/VERSION" - where version is current VideoInfo version, e.g. **"VideoInfo/0.2.7"**.

It supports all openURI header fields (options), for more information see: [openURI DOCS](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/open-uri/rdoc/OpenURI.html)

You can also include an `iframe_attributes` or `url_attributes` hash to the `embed_code` method to include arbitrary attributes in the iframe embed code or as additional URL params:

``` ruby
VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4').embed_code(iframe_attributes: { width: 800, height: 600, 'data-key' => 'value' })
=> '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4" frameborder="0" allowfullscreen="allowfullscreen" width="800" height="600" data-key="value"></iframe>'

'VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4').embed_code(url_attributes: { autoplay: 1 })
=> '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4?autoplay=1" frameborder="0" allowfullscreen="allowfullscreen"></iframe>'
```

If you would like to disable certain providers, you can do so by modifying the class variable `disable_providers`:

``` ruby
VideoInfo.disable_providers = %w[YouTube] # disable YouTube
VideoInfo.disable_providers = %w[Vimeo YouTube] # disable Vimeo and Youtube
VideoInfo.disable_providers = [] # enable all providers
```

Note: `disable_providers` is case-insensitive. Attempting to use a disabled provider will raise a UrlError, just like attempting to use a
non-video URL.

Author
------

[Thibaud Guillaume-Gentil](https://github.com/thibaudgg) ([@thibaudgg](https://twitter.com/thibaudgg))

Maintainers
-----------

[Thibaud Guillaume-Gentil](https://github.com/thibaudgg) ([@thibaudgg](https://twitter.com/thibaudgg))
[Vincent Heuken](https://github.com/vheuken) ([@vheuken](https://github.com/vheuken))

Contributors
------------

[https://github.com/thibaudgg/video_info/graphs/contributors](https://github.com/thibaudgg/video_info/graphs/contributors)
