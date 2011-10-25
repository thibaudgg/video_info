require 'spec_helper'

describe "VideoInfo" do

  context "from Youtube" do
    describe "Video mZqGqE0D0n4" do
      use_vcr_cassette "youtube/mZqGqE0D0n4"
      subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

      its(:provider)         { should == 'YouTube' }
      its(:video_id)         { should == 'mZqGqE0D0n4' }
      its(:url)              { should == 'http://www.youtube.com/watch?v=mZqGqE0D0n4' }
      its(:title)            { should == 'Cherry Bloom - King Of The Knife' }
      its(:description)      { should == 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
      its(:keywords)         { should == 'cherry, bloom, king, of, the, knife, guitar, drum, clip, rock, alternative, tremplin, Paris-Forum' }
      its(:duration)         { should == 175 }
      its(:width)            { should be_nil }
      its(:height)           { should be_nil }
      its(:date)             { should == Time.parse('Sat Apr 12 22:25:35 UTC 2008', Time.now.utc) }
      its(:thumbnail_small)  { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/1.jpg' }
      its(:thumbnail_large)  { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/0.jpg' }
      its(:view_count)       { should be > 4000 }
      it { should be_valid }
    end

    describe "Video JM9NgvjjVng" do
      use_vcr_cassette "youtube/JM9NgvjjVng"
      subject { VideoInfo.new('http://www.youtube.com/watch?v=JM9NgvjjVng') }

      its(:provider)         { should == 'YouTube' }
      its(:duration)         { should == 217 }
      it { should be_valid }
    end

    describe "Video oQ49W_xKzKA" do
      use_vcr_cassette "youtube/oQ49W_xKzKA"
      subject { VideoInfo.new('http://www.youtube.com/watch?v=oQ49W_xKzKA') }

      its(:view_count) { should == 2 }
    end

    describe "youtu.be url" do
      use_vcr_cassette "youtube/JM9NgvjjVng"
      subject { VideoInfo.new('http://youtu.be/JM9NgvjjVng') }
      its(:provider) { should == 'YouTube' }
    end
  end

  context "from Vimeo" do
    describe "Video 898029" do
      use_vcr_cassette "vimeo/898029"
      subject { VideoInfo.new('http://www.vimeo.com/898029') }

      its(:provider)         { should == 'Vimeo' }
      its(:video_id)         { should == '898029' }
      its(:url)              { should == 'http://vimeo.com/898029' }
      its(:title)            { should == 'Cherry Bloom - King Of The Knife' }
      its(:description)      { should == 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
      its(:keywords)         { should == 'cherry bloom, secret sounds, king of the knife, rock, alternative' }
      its(:duration)         { should == 175 }
      its(:width)            { should == 640 }
      its(:height)           { should == 360 }
      its(:date)             { should == Time.parse('Mon Apr 14 13:10:39 +0200 2008', Time.now.utc) }
      its(:thumbnail_small)  { should == 'http://b.vimeocdn.com/ts/343/731/34373130_100.jpg' }
      its(:thumbnail_large)  { should == 'http://b.vimeocdn.com/ts/343/731/34373130_640.jpg' }
      its(:view_count)       { should be > 4000 }
      it { should be_valid }
    end
  end

  context "from" do
    describe "misstaped url" do
      subject { VideoInfo.new('http://www.vimo.com/1') }

      it { should_not be_valid }
    end
    describe "bad url" do
      subject { VideoInfo.new('http://www.yasda.com/asdasd') }

      it { should_not be_valid }
    end
    describe "blank url" do
      subject { VideoInfo.new('') }

      it { should_not be_valid }
    end
    describe "nil url" do
      subject { VideoInfo.new(nil) }

      it { should_not be_valid }
    end
  end

end
