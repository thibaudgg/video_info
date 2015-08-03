require 'spec_helper'

describe VideoInfo::Providers::Youtube do
  before(:all) do
    VideoInfo.provider_api_keys = { youtube: 'AIzaSyA6PYwSr1EnLFUFy1cZDk3Ifb0rxeJaeZ0' }
  end

  describe ".usable?" do
    subject { VideoInfo::Providers::Youtube.usable?(url) }

    context "with youtube.com url" do
      let(:url) { 'http://www.youtube.com/watch?v=Xp6CXF' }
      it { is_expected.to be_truthy }
    end

    context "with youtu.be url" do
      let(:url) { 'http://youtu.be/JM9NgvjjVng' }
      it { is_expected.to be_truthy }
    end

    context "with other url" do
      let(:url) { 'http://google.com/video1' }
      it { is_expected.to be_falsey }
    end

    context "with playlist url" do
      let(:url) { 'http://www.youtube.com/playlist?p=PLA575C81A1FBC04CF' }
      it { is_expected.to be_falsey }
    end
  end

  describe "#available?" do
    context "with valid video", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end

    context "with 'video is unavailable' video", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=SUkXvWn1m7Q') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_falsey }
      end

      describe '#provider' do
        subject { super().provider }
        it { is_expected.to eq 'YouTube' }
      end

      describe '#video_id' do
        subject { super().video_id }
        it { is_expected.to eq 'SUkXvWn1m7Q' }
      end

      describe '#url' do
        subject { super().url }
        it { is_expected.to eq 'http://www.youtube.com/watch?v=SUkXvWn1m7Q' }
      end

      describe '#embed_url' do
        subject { super().embed_url }
        it { is_expected.to eq '//www.youtube.com/embed/SUkXvWn1m7Q' }
      end

      describe '#embed_code' do
        subject { super().embed_code }
        it { is_expected.to eq '<iframe src="//www.youtube.com/embed/SUkXvWn1m7Q" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
      end

      describe '#title' do
        subject { super().title }
        it { is_expected.to eq nil }
      end

      describe '#description' do
        subject { super().description }
        it { is_expected.to eq nil }
      end

      describe '#keywords' do
        subject { super().keywords }
        it { is_expected.to be_nil }
      end

      describe '#duration' do
        subject { super().duration }
        it { is_expected.to eq 0 }
      end

      describe '#date' do
        subject { super().date }
        it { is_expected.to eq nil }
      end

      describe '#thumbnail_small' do
        subject { super().thumbnail_small }
        it { is_expected.to eq 'https://i.ytimg.com/vi/SUkXvWn1m7Q/default.jpg' }
      end

      describe '#thumbnail_medium' do
        subject { super().thumbnail_medium }
        it { is_expected.to eq 'https://i.ytimg.com/vi/SUkXvWn1m7Q/mqdefault.jpg' }
      end

      describe '#thumbnail_large' do
        subject { super().thumbnail_large }
        it { is_expected.to eq 'https://i.ytimg.com/vi/SUkXvWn1m7Q/hqdefault.jpg' }
      end

      describe '#view_count' do
        subject { super().view_count }
        it { is_expected.to be == 0 }
      end
    end

    context "with 'video no longer available due to a copyright claim' video", :vcr do
      subject { VideoInfo.new('http://www.youtube.com/watch?v=ffClNhwx0KU') }

      describe '#available?' do
        subject { super().available? }
        it { is_expected.to be_truthy }
      end
    end
  end

  context "with video mZqGqE0D0n4", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'mZqGqE0D0n4' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://www.youtube.com/watch?v=mZqGqE0D0n4' }
    end

    describe '#embed_url' do
      subject { super().embed_url }
      it { is_expected.to eq '//www.youtube.com/embed/mZqGqE0D0n4' }
    end

    describe '#embed_code' do
      subject { super().embed_code }
      it { is_expected.to eq '<iframe src="//www.youtube.com/embed/mZqGqE0D0n4" frameborder="0" allowfullscreen="allowfullscreen"></iframe>' }
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq 'Cherry Bloom - King Of The Knife' }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq 'The first video from the upcoming album Secret Sounds, to download in-stores April 14. Checkout http://www.cherrybloom.net' }
    end

    describe '#keywords' do
      subject { super().keywords }
      it { is_expected.to eq %w(cherry bloom king of the knife guitar drum clip rock alternative tremplin Paris-Forum) }
    end

    describe '#duration' do
      subject { super().duration }
      it { is_expected.to eq 176 }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to be_nil }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to be_nil }
    end

    describe '#date' do
      subject { super().date }
      it { is_expected.to eq Time.parse('Sat Apr 12 22:25:35 UTC 2008', Time.now.utc) }
    end

    describe '#thumbnail_small' do
      subject { super().thumbnail_small }
      it { is_expected.to eq 'https://i.ytimg.com/vi/mZqGqE0D0n4/default.jpg' }
    end

    describe '#thumbnail_medium' do
      subject { super().thumbnail_medium }
      it { is_expected.to eq 'https://i.ytimg.com/vi/mZqGqE0D0n4/mqdefault.jpg' }
    end

    describe '#thumbnail_large' do
      subject { super().thumbnail_large }
      it { is_expected.to eq 'https://i.ytimg.com/vi/mZqGqE0D0n4/hqdefault.jpg' }
    end

    describe '#view_count' do
      subject { super().view_count }
      it { is_expected.to be > 4000 }
    end
  end

  context "with video oQ49W_xKzKA", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=oQ49W_xKzKA') }

    it { expect(subject.embed_code(url_attributes: { autoplay: 1 })).to match(/autoplay=1/) }
  end

  context "with video oQ49W_xKzKA", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=oQ49W_xKzKA') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'oQ49W_xKzKA' }
    end
  end

  context "with video Xp6CXF-Cesg", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=Xp6CXF-Cesg') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'Xp6CXF-Cesg' }
    end
  end

  context "with video VeasFckfMHY in user url", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/user/EducatorVids3?v=VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://www.youtube.com/user/EducatorVids3?v=VeasFckfMHY' }
    end
  end

  context "with video VeasFckfMHY after params", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?feature=player_profilepage&v=VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end

    describe '#url' do
      subject { super().url }
      it { is_expected.to eq 'http://www.youtube.com/watch?feature=player_profilepage&v=VeasFckfMHY' }
    end
  end

  context "with video VeasFckfMHY in path", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/v/VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end
  end

  context "with video VeasFckfMHY in e path", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/e/VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end
  end

  context "with video VeasFckfMHY in embed path", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/embed/VeasFckfMHY') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'VeasFckfMHY' }
    end
  end

  context "with video JM9NgvjjVng in youtu.be url", :vcr do
    subject { VideoInfo.new('http://youtu.be/JM9NgvjjVng') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq 'YouTube' }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'JM9NgvjjVng' }
    end
  end

  context 'without http or www', :vcr do
    subject { VideoInfo.new('youtu.be/JM9NgvjjVng') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq 'JM9NgvjjVng' }
    end
  end

  context "with video url in text", :vcr do
    subject { VideoInfo.new('<a href="http://www.youtube.com/watch?v=mZqGqE0D0n4">http://www.youtube.com/watch?v=mZqGqE0D0n4</a>') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end

    describe '#video_id' do
      subject { super().video_id }
      it { is_expected.to eq('mZqGqE0D0n4') }
    end
  end

  context "with iframe attributes", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end
    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/width="800"/) }
    it { expect(subject.embed_code(iframe_attributes: { width: 800, height: 600 })).to match(/height="600"/) }
  end

  context "with arbitrary iframe_attributes", :vcr do
    subject { VideoInfo.new('http://www.youtube.com/watch?v=mZqGqE0D0n4') }

    describe '#provider' do
      subject { super().provider }
      it { is_expected.to eq('YouTube') }
    end
    it { expect(subject.embed_code(iframe_attributes: { :'data-colorbox' => true })).to match(/data-colorbox="true"/) }
  end

end
