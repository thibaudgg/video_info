require 'spec_helper'

describe VideoInfo do
  context "from" do
    describe "misstaped url" do
      subject { VideoInfo.get('http://www.vimo.com/1') }

      it { should be_nil }
    end

    describe "bad url" do
      subject { VideoInfo.get('http://www.yasda.com/asdasd') }

      it { should be_nil }
    end

    describe "blank url" do
      subject { VideoInfo.get('') }

      it { should be_nil }
    end

    describe "nil url" do
      subject { VideoInfo.get(nil) }

      it { should be_nil }
    end
  end

  context "options" do
    let!(:default_user_agent) { "VideoInfo/#{VideoInfo::VERSION}" }
    let!(:custom_user_agent)  { "Test User Agent / 1.0" }
    let!(:custom_referer)     { "http://google.com" }

    describe "no options specified" do
      use_vcr_cassette "vimeo/898029"
      subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029') }

      its(:openURI_options) { should == { "User-Agent" => default_user_agent } }
    end

    describe "symbols used" do
      use_vcr_cassette "vimeo/898029"
      subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', :user_agent => custom_user_agent, :referer => custom_referer ) }

      its(:openURI_options) { should == { "User-Agent" => custom_user_agent, "Referer" => custom_referer } }
    end

    describe "strings used" do
      use_vcr_cassette "vimeo/898029"
      subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', "User-Agent" => custom_user_agent, "Referer" => custom_referer ) }

      its(:openURI_options) { should == { "User-Agent" => custom_user_agent, "Referer" => custom_referer } }
    end

    describe "reserved openURI option-keys used" do
      # Depending on Ruby version, the size of reserved-keys list may vary, see: OpenURI::Options.keys
      use_vcr_cassette "vimeo/898029"
      subject { VideoInfo.get('http://vimeo.com/groups/1234/videos/898029', :proxy => nil, :http_basic_authentication => true) }

      its(:openURI_options) { should == { "User-Agent" => default_user_agent, :proxy => nil, :http_basic_authentication => true } }
    end
  end
end
