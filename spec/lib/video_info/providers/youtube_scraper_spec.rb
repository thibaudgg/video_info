require 'spec_helper'

describe VideoInfo::Providers::Youtube do
  context 'with a video without description', :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=WVsj2pS-zFY') }

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq " " }
    end
  end
end
