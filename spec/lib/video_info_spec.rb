require 'spec_helper'

describe VideoInfo do

  describe ".get" do
    let(:url) { 'url' }
    let(:options) { { :foo => :bar } }
    let(:provider) { double('provider') }

    it "uses the first usable provider" do
      VideoInfo::Providers::Vimeo.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Vkontakte.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Youtube.should_receive(:usable?).with(url) { true }
      VideoInfo::Providers::Youtube.should_receive(:new).with(url, options) { provider }

      VideoInfo.get(url, options).should eq provider
    end

    it "returns nil when no providers are usable" do
      VideoInfo::Providers::Vimeo.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Vkontakte.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Youtube.should_receive(:usable?).with(url) { false }

      VideoInfo.get(url, options).should be_nil
    end
  end

  describe ".usable?" do
    let(:url) { 'url' }
    let(:options) { { :foo => :bar } }
    let(:provider) { double('provider') }

    it "returns true when a provider is usable" do
      VideoInfo::Providers::Vimeo.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Vkontakte.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Youtube.should_receive(:usable?).with(url) { true }

      VideoInfo.usable?(url).should be_true
    end

    it "returns false when no providers are usable" do
      VideoInfo::Providers::Vimeo.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Vkontakte.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Youtube.should_receive(:usable?).with(url) { false }

      VideoInfo.usable?(url).should be_false
    end
  end

end
