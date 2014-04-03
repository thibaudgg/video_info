# encoding: UTF-8
require 'spec_helper'

describe VideoInfo::Providers::Vkontakte do

  describe ".usable?" do
    subject { VideoInfo::Providers::Vkontakte.usable?(url) }

    context "with vkontakte url" do
      let(:url) { 'http://vk.com/video39576223_108370515' }
      it { should be_true }
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/898029' }
      it { should be_false }
    end
  end

  describe "#available?" do
    context "with valid video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_108370515') }
      its(:available?)       { should be_true }
    end

    context "with invalid video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_invalid') }
      its(:available?)       { should be_false }
    end

  end

  context "with video video39576223_108370515", :vcr do
    subject { VideoInfo.new('http://vk.com/video39576223_108370515') }

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '39576223' }
    its(:video_id)         { should eq '108370515' }
    its(:url)              { should eq 'http://vk.com/video39576223_108370515' }
    its(:embed_url)        { should eq '//vk.com/video_ext.php?oid=39576223&id=108370515&hash=15184dbd085c47af' }
    its(:embed_code)       { should eq '<iframe src="//vk.com/video_ext.php?oid=39576223&id=108370515&hash=15184dbd085c47af" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    its(:title)            { should eq 'Я уточка))))) | VK' }
    its(:description)      { should eq 'это ВЗРЫВ МОЗГА!!! Просто отвал башки...' }
    its(:keywords)         { should eq 'это ВЗРЫВ МОЗГА!!! Просто отвал башки...' }
    its(:duration)         { should eq 183 }
    its(:width)            { should eq 320 }
    its(:height)           { should eq 240 }
    its(:view_count)       { should be > 10 }
  end

  context "with video video-54799401_165822734", :vcr do
    subject { VideoInfo.new('http://vk.com/video-54799401_165822734') }

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '-54799401' }
    its(:video_id)         { should eq '165822734' }
    its(:title)            { should eq 'SpaceGlasses are the future of computing | VK' }
  end

end
