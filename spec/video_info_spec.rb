require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "VideoInfo" do

  describe "from Youtube" do
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
    its(:date)             { should == Time.parse('Sat Apr 12 22:25:35 UTC 2008') }
    its(:thumbnail_small)  { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/2.jpg' }
    its(:thumbnail_large)  { should == 'http://i.ytimg.com/vi/mZqGqE0D0n4/0.jpg' }
    it { should be_valid }
  end
  
  describe "from Vimeo" do
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
    its(:date)             { should == Time.parse('Mon Apr 14 13:10:39 +0200 2008') }
    its(:thumbnail_small)  { should == 'http://ts.vimeo.com.s3.amazonaws.com/343/731/34373130_100.jpg' }
    its(:thumbnail_large)  { should == 'http://ts.vimeo.com.s3.amazonaws.com/343/731/34373130_640.jpg' }
    it { should be_valid }
  end
  
  it "should be invalid with misstaped url" do
    video = VideoInfo.new('http://www.vimeo.com/1')
    video.should_not be_valid
  end
  
  it "should be invalid with bad url" do
    video = VideoInfo.new('http://www.yasda.com/asdasd')
    video.should_not be_valid
  end
  
  it "should be invalid with blank url" do
    video = VideoInfo.new('')
    video.should_not be_valid
  end
  
  it "should be invalid with nil url" do
    video = VideoInfo.new(nil)
    video.should_not be_valid
  end
  
end