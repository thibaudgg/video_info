require 'spec_helper'

describe VideoInfo::Providers::Youtube do

  describe ".usable?" do
    subject { VideoInfo::Providers::Youtube.usable?(url) }

    context "with youtube.com url" do
      let(:url) { 'http://www.youtube.com/watch?v=Xp6CXF' }
      it { should be_true }
    end

    context "with youtu.be url" do
      let(:url) { 'http://youtu.be/JM9NgvjjVng' }
      it { should be_true }
    end

    context "with other url" do
      let(:url) { 'http://google.com/video1' }
      it { should be_false }
    end
  end

  context "with video mZqGqE0D0n4", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    its(:provider)         { should eq 'YouTube' }
    its(:video_id)         { should eq 'mZqGqE0D0n4' }
    its(:url)              { should eq 'http://www.youtube.com/watch?v=mZqGqE0D0n4' }
    its(:embed_url)        { should eq 'http://www.youtube.com/embed/mZqGqE0D0n4' }
    its(:embed_code)       { should eq '<iframe src="http://www.youtube.com/embed/mZqGqE0D0n4" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    its(:title)            { should eq 'Cherry Bloom - King Of The Knife' }
    its(:description)      { should eq 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
    its(:keywords)         { should be_nil }
    its(:duration)         { should eq 175 }
    its(:width)            { should be_nil }
    its(:height)           { should be_nil }
    its(:date)             { should eq Time.parse('Sat Apr 12 22:25:35 UTC 2008', Time.now.utc) }
    its(:thumbnail_small)  { should eq 'http://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg' }
    its(:thumbnail_medium) { should eq 'http://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg' }
    its(:thumbnail_large)  { should eq 'http://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg' }
    its(:view_count)       { should be > 4000 }
  end

  context "with video oQ49W_xKzKA", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?v=oQ49W_xKzKA') }

    it { subject.embed_code(:url_attributes => { :autoplay => 1 }).should match(/autoplay=1/) }
  end

  context "with video oQ49W_xKzKA", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?v=oQ49W_xKzKA') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'oQ49W_xKzKA' }
  end

  context "with video Xp6CXF-Cesg", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?v=Xp6CXF-Cesg') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'Xp6CXF-Cesg' }
  end

  context "with video VeasFckfMHY in user url", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/user/EducatorVids3?v=VeasFckfMHY') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'VeasFckfMHY' }
    its(:url)      { should eq 'http://www.youtube.com/user/EducatorVids3?v=VeasFckfMHY' }
  end

  context "with video VeasFckfMHY after params", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?feature=player_profilepage&v=VeasFckfMHY') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'VeasFckfMHY' }
    its(:url)      { should eq 'http://www.youtube.com/watch?feature=player_profilepage&v=VeasFckfMHY' }
  end

  context "with video VeasFckfMHY in path", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/v/VeasFckfMHY') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'VeasFckfMHY' }
  end

  context "with video VeasFckfMHY in e path", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/e/VeasFckfMHY') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'VeasFckfMHY' }
  end

  context "with video VeasFckfMHY in embed path", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/embed/VeasFckfMHY') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'VeasFckfMHY' }
  end

  context "with video JM9NgvjjVng in youtu.be url", :vcr do
    subject { VideoInfo.get('http://youtu.be/JM9NgvjjVng') }

    its(:provider) { should eq 'YouTube' }
    its(:video_id) { should eq 'JM9NgvjjVng' }
  end

  context 'without http or www', :vcr do
    subject { VideoInfo.get('youtu.be/JM9NgvjjVng') }

    its(:provider) { should == 'YouTube' }
    its(:video_id) { should eq 'JM9NgvjjVng' }
  end

  context "with video url in text", :vcr do
    subject { VideoInfo.get('<a href="http://www.youtube.com/watch?v=mZqGqE0D0n4">http://www.youtube.com/watch?v=mZqGqE0D0n4</a>') }

    its(:provider) { should == 'YouTube' }
    its(:video_id) { should == 'mZqGqE0D0n4' }
  end

  context "with iframe attributes", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    its(:provider) { should == 'YouTube' }
    it { subject.embed_code(:iframe_attributes => { :width => 800, :height => 600 }).should match(/width="800"/) }
    it { subject.embed_code(:iframe_attributes => { :width => 800, :height => 600 }).should match(/height="600"/) }
  end

  context "with arbitrary iframe_attributes", :vcr do
    subject { VideoInfo.get('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    its(:provider)   { should == 'YouTube' }
    it { subject.embed_code(:iframe_attributes => { :'data-colorbox' => true }).should match(/data-colorbox="true"/) }
  end

end
