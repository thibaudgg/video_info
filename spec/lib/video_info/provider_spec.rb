require 'spec_helper'

describe VideoInfo::Provider do

  class ProviderFu < VideoInfo::Provider
    def _url_regex
      /foo\/(\d)/
    end
  end

  describe "initialize" do
    let(:url) { 'url' }
    let(:options) { { } }
    let(:provider) { ProviderFu.new(url, options) }

    it { expect { VideoInfo::Provider.new(url) }.to raise_error(NotImplementedError, 'Provider class must implement #_url_regex private method') }
    it { expect { ProviderFu.new('foo/1') }.to raise_error(NotImplementedError, 'Provider class must implement #_api_url private method') }

    it "sets default user_agent options" do
      provider.options.should eq({ 'User-Agent' => "VideoInfo/#{VideoInfo::VERSION}" })
    end

    context "with custom User-Agent options" do
      let(:options) { { 'User-Agent' => 'Test User Agent / 1.0' } }

      it "sets the option" do
        provider.options.should eq({ 'User-Agent' => 'Test User Agent / 1.0' })
      end
    end

    context "with Referer options" do
      let(:options) { { :referer => 'http://google.com' } }

      it "sets the option" do
        provider.options.should include({ 'Referer' => 'http://google.com' })
      end
    end
  end

  describe ".usable?" do
    it { expect { VideoInfo::Provider.usable?('url') }.to raise_error(NotImplementedError, 'Provider class must implement .usable? public method') }
  end

end
