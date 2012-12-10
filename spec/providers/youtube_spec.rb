require 'spec_helper'

describe VideoInfo::Youtube do
  describe "info", :vcr do
    subject { VideoInfo::Youtube.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    it                     { should be_valid }
    its(:provider)         { should == 'YouTube' }
    its(:video_id)         { should == 'mZqGqE0D0n4' }
    its(:url)              { should == 'http://www.youtube.com/watch?v=mZqGqE0D0n4' }
    its(:embed_url)        { should == 'http://www.youtube.com/embed/mZqGqE0D0n4' }
    its(:embed_code)       { should == '<iframe src="http://www.youtube.com/embed/mZqGqE0D0n4" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    its(:title)            { should == 'Cherry Bloom - King Of The Knife' }
    its(:description)      { should == 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
    its(:keywords)         { should be_nil }
    its(:duration)         { should == 175 }
    its(:width)            { should be_nil }
    its(:height)           { should be_nil }
    its(:date)             { should == Time.parse('Sat Apr 12 22:25:35 UTC 2008', Time.now.utc) }
    its(:thumbnail_small)  { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg' }
    its(:thumbnail_medium) { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg' }
    its(:thumbnail_large)  { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg' }
    its(:view_count)       { should be > 4000 }
  end

  describe "Video JM9NgvjjVng", :vcr do
    subject { VideoInfo::Youtube.new('http://www.youtube.com/watch?v=JM9NgvjjVng') }

    it             { should be_valid }
    its(:provider) { should == 'YouTube' }
    its(:duration) { should == 217 }
  end

  describe "Video oQ49W_xKzKA", :vcr do
    subject { VideoInfo::Youtube.new('http://www.youtube.com/watch?v=oQ49W_xKzKA') }

    its(:view_count) { should be > 2 }
  end

  describe "Video Xp6CXF-Cesg", :vcr do
    subject { VideoInfo::Youtube.new('http://www.youtube.com/watch?v=Xp6CXF-Cesg') }

    its(:view_count) { should be > 893735 }
  end

  describe "youtu.be url", :vcr do
    subject { VideoInfo::Youtube.new('http://youtu.be/JM9NgvjjVng') }

    its(:provider) { should == 'YouTube' }
  end

  context 'without http or www', :vcr do
    subject { VideoInfo::Youtube.new('youtu.be/JM9NgvjjVng') }

    its(:provider) { should == 'YouTube' }
  end

  describe "iframe attributes youtube", :vcr do
    subject { VideoInfo::Youtube.new('http://www.youtube.com/watch?v=mZqGqE0D0n4', :iframe_attributes => { :width => 800, :height => 600 }) }

    its(:embed_code) { should match(/width="800"/) }
    its(:embed_code) { should match(/height="600"/) }
  end

  describe "iframe attributes arbitrary", :vcr do
    subject { VideoInfo::Youtube.new('http://www.youtube.com/watch?v=mZqGqE0D0n4', :iframe_attributes => { "data-colorbox" => "true" } ) }

    its(:embed_code) { should match(/data-colorbox="true"/) }
  end

  describe "url in text", :vcr do
    let(:text) { '<a href="http://www.youtube.com/watch?v=mZqGqE0D0n4">http://www.youtube.com/watch?v=mZqGqE0D0n4</a>' }
    subject { VideoInfo::Youtube.new(text) }

    it { should be_valid }
    its(:video_id) { should == 'mZqGqE0D0n4' }
  end
end
