require 'spec_helper'

describe VideoInfo do

  describe ".get" do
    let(:url) { 'url' }
    let(:options) { { foo: :bar } }
    let(:provider) { mock('provider') }

    it "uses the first usable provider" do
      VideoInfo::Providers::Vimeo.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Youtube.should_receive(:usable?).with(url) { true }
      VideoInfo::Providers::Youtube.should_receive(:new).with(url, options) { provider }

      VideoInfo.get(url, options).should eq provider
    end

    it "returns nil when no providers are usable" do
      VideoInfo::Providers::Vimeo.should_receive(:usable?).with(url) { false }
      VideoInfo::Providers::Youtube.should_receive(:usable?).with(url) { false }

      VideoInfo.get(url, options).should be_nil
    end
  end
  # context "from" do
  #   describe "misstaped url" do
  #     subject { VideoInfo.get('http://www.vimo.com/1') }

  #     it { should be_nil }
  #   end

  #   describe "bad url" do
  #     subject { VideoInfo.get('http://www.yasda.com/asdasd') }

  #     it { should be_nil }
  #   end

  #   describe "blank url" do
  #     subject { VideoInfo.get('') }

  #     it { should be_nil }
  #   end

  #   describe "not valid id url", :vcr do
  #     subject { VideoInfo.get('http://www.vimeo.com/000000000') }

  #     it { should be_nil }
  #   end

  #   describe "nil url" do
  #     subject { VideoInfo.get(nil) }

  #     it { should be_nil }
  #   end
  # end

  # context "options" do
  #   let!(:default_user_agent) { "VideoInfo/#{VideoInfo::VERSION}" }
  #   let!(:custom_user_agent)  { "Test User Agent / 1.0" }
  #   let!(:custom_referer)     { "http://google.com" }

  #   describe "no options specified", :vcr do
  #     subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029') }

  #     its(:options) { should == { "User-Agent" => default_user_agent } }
  #   end

  #   describe "symbols used", :vcr do
  #     subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', :user_agent => custom_user_agent, :referer => custom_referer ) }

  #     its(:options) { should == { "User-Agent" => custom_user_agent, "Referer" => custom_referer } }
  #   end

  #   describe "strings used", :vcr do
  #     subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', "User-Agent" => custom_user_agent, "Referer" => custom_referer ) }

  #     its(:options) { should == { "User-Agent" => custom_user_agent, "Referer" => custom_referer } }
  #   end

  #   describe "reserved openURI option-keys used", :vcr do
  #     # Depending on Ruby version, the size of reserved-keys list may vary, see: OpenURI::Options.keys
  #     subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', :proxy => nil, :http_basic_authentication => true) }

  #     its(:options) { should == { "User-Agent" => default_user_agent, :proxy => nil, :http_basic_authentication => true } }
  #   end

  #   describe "iframe_attributes options used", :vcr do
  #     # Depending on Ruby version, the size of reserved-keys list may vary, see: OpenURI::Options.keys
  #     subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', :iframe_attributes => { :width => 800, :height => 600,  "data-colorbox" => "true" }) }

  #     its(:iframe_attributes) { should eq " width=\"800\" height=\"600\" data-colorbox=\"true\"" }
  #     its(:options) { should == { "User-Agent" => default_user_agent } }
  #   end
  # end
end
