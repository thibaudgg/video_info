# encoding: UTF-8
require 'spec_helper'

describe VideoInfo::Providers::Vkontakte do

  describe ".usable?" do
    subject { VideoInfo::Providers::Vkontakte.usable?(url) }

    context "with vkontakte url" do
      context "old style", :vcr do
        let(:url) { 'http://vk.com/video39576223_108370515' }
        it { should be_truthy }
      end

      context "new style", :vcr do
        let(:url) { 'https://vk.com/kirill.lyanoi?z=video2152699_168591741%2F56fd229a9dfe2dcdbe' }
        it { should be_truthy }
      end
    end

    context "with other url" do
      let(:url) { 'http://www.youtube.com/898029' }
      it { should be_falsey }
    end

    context "with invalid url" do
      let(:url) { 'http://vk.com just random data' }
      it { should be_falsey }
    end

    context "with spaces at end" do
      let(:url) { 'http://vk.com/video39576223_108370515        ' }
      it { should be_truthy }
    end

    context "with spaces at start" do
      let(:url) { '      http://vk.com/video39576223_108370515' }
      it { should be_truthy }
    end

    context "with spaces around url" do
      let(:url) { '      http://vk.com/video39576223_108370515      ' }
      it { should be_truthy }
    end
  end

  describe "#available?" do
    context "with valid video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_108370515') }
      its(:available?)       { should be_truthy }
    end

    context "with invalid video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_invalid') }
      its(:available?)       { should be_falsey }
    end

    context "with private video", :vcr do
      subject { VideoInfo.new('http://vk.com/video39576223_166315543') }
      its(:available?)       { should be_falsey }
    end

    context "with redirect", :vcr do
      subject { VideoInfo.new('http://vk.com/polinka_zh?z=video186965901_168185427%2Fbfb2bd2e674031520a') }
      its(:available?)       { should be_truthy }
    end

    context "with redirect to main page for auth", :vcr do
      subject { VideoInfo.new('http://vk.com/video?z=video1472940_169081944%2Falbum1472940') }
      its(:available?)       { should be_falsey }
    end

    context "with hashes", :vcr do
      subject { VideoInfo.new('https://vk.com/videos43640822#/video43640822_168790809') }
      its(:available?)       { should be_truthy }
    end

  end

  context "with video videos43640822#/video43640822_168790809", :vcr do
    subject { VideoInfo.new('https://vk.com/videos43640822#/video43640822_168790809') }

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '43640822' }
    its(:video_id)         { should eq '168790809' }
    its(:title)            { should eq 'UDC open cup 2014/ 3 place / Saley Daria (solo)' }
  end

  context "with video kirill.lyanoi?z=video2152699_168591741%2F56fd229a9dfe2dcdbe", :vcr do
    subject { VideoInfo.new('https://vk.com/kirill.lyanoi?z=video2152699_168591741%2F56fd229a9dfe2dcdbe') }

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '2152699' }
    its(:video_id)         { should eq '168591741' }
    its(:url)              { should eq 'https://vk.com/kirill.lyanoi?z=video2152699_168591741%2F56fd229a9dfe2dcdbe' }
    its(:embed_url)        { should eq '//www.youtube.com/embed/4Thws5wq5GI' }
    its(:embed_code)       { should eq '<iframe src="//www.youtube.com/embed/4Thws5wq5GI" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    its(:title)            { should eq 'BEAT SOUL STEP — RDC14 Project818 Russian Dance Championship, May 1-2, Moscow 2014' }
    its(:description)      { should start_with 'BEAT SOUL STEP ★ Project818 Russian Dance Championship ★ 1-2 мая, Москва 2014' }
    its(:keywords)         { should start_with 'BEAT SOUL STEP ★ Project818 Russian Dance Championship ★ 1-2 мая, Москва 2014' }
    its(:duration)         { should eq 299 }
    its(:width)            { should eq 0 }
    its(:height)           { should eq 0 }
    its(:view_count)       { should be > 10 }
  end

  context "with video video39576223_108370515", :vcr do
    subject { VideoInfo.new('http://vk.com/video39576223_108370515') }

    its(:provider)         { should eq 'Vkontakte' }
    its(:video_owner)      { should eq '39576223' }
    its(:video_id)         { should eq '108370515' }
    its(:url)              { should eq 'http://vk.com/video39576223_108370515' }
    its(:embed_url)        { should eq '//vk.com/video_ext.php?oid=39576223&id=108370515&hash=15184dbd085c47af' }
    its(:embed_code)       { should eq '<iframe src="//vk.com/video_ext.php?oid=39576223&id=108370515&hash=15184dbd085c47af" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    its(:title)            { should eq 'Я уточка)))))' }
    its(:description)      { should eq 'это ВЗРЫВ МОЗГА!!!<br>Просто отвал башки...' }
    its(:keywords)         { should eq 'это ВЗРЫВ МОЗГА!!!<br>Просто отвал башки...' }
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
    its(:title)            { should eq 'SpaceGlasses are the future of computing' }
  end

end
