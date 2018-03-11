require 'spec_helper'

describe VideoInfo::Providers::Youtube do
  context 'with video WVsj2pS-zFY' do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=WVsj2pS-zFY') }

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq nil }
    end
  end
end
