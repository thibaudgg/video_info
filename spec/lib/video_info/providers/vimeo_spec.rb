[nil, ENV["VIMEO_ACCESS_TOKEN"] || "vimeo_access_token"].each do |api_key|
  describe VideoInfo::Providers::Vimeo, :vcr do
    before(:all) do
      VideoInfo.provider_api_keys = {vimeo: api_key}
    end

    describe ".usable?" do
      subject { VideoInfo::Providers::Vimeo.usable?(url) }

      context "with vimeo url" do
        let(:url) { "http://www.vimeo.com/898029" }
        it { is_expected.to be_truthy }
      end

      context "with Vimeo OnDemand url" do
        let(:url) { "https://vimeo.com/ondemand/less/101677664" }
        it { is_expected.to be_truthy }
      end

      context "with Vimeo Channels url" do
        let(:url) { "https://vimeo.com/channels/any_channel/111431415" }
        it { is_expected.to be_truthy }
      end

      context "with Vimeo Review url" do
        video_url = "https://vimeo.com/user39798190/review/126641548/8a56234e32"
        let(:url) { video_url }
        it { is_expected.to be_truthy }
      end

      context "with vimeo album url" do
        let(:url) { "http://vimeo.com/album/2755718" }
        it { is_expected.to be_falsey }
      end

      context "with vimeo hubnub embed url" do
        let(:url) { "http://player.vimeo.com/hubnut/album/2755718" }
        it { is_expected.to be_falsey }
      end

      context "with other url" do
        let(:url) { "http://www.youtube.com/898029" }
        it { is_expected.to be_falsey }
      end
    end

    describe "#available?" do
      context "with valid video" do
        subject { VideoInfo.new("http://vimeo.com/98605382") }

        describe "#available?" do
          it { is_expected.to be_available }
        end
      end

      context "with 'this video does not exist' video" do
        subject { VideoInfo.new("http://vimeo.com/59312311") }

        describe "#available?" do
          it { is_expected.to_not be_available }
        end
      end

      context "with 'password required' video" do
        subject { VideoInfo.new("http://vimeo.com/74636562") }

        describe "#available?" do
          it { is_expected.to_not be_available }
        end
      end
    end

    context "with video 136971428" do
      subject { VideoInfo.new("https://vimeo.com/136971428") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "Vimeo" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "136971428" }
      end

      describe "#url" do
        subject { super().url }
        it { is_expected.to eq "https://vimeo.com/136971428" }
      end

      describe "#embed_url" do
        subject { super().embed_url }
        it { is_expected.to eq "//player.vimeo.com/video/136971428" }
      end

      describe "#embed_code" do
        subject { super().embed_code }
        embed_code = '<iframe src="//player.vimeo.com/video/136971428?' \
                     'title=0&byline=0&portrait=0&autoplay=0" ' \
                     'frameborder="0"></iframe>'
        it { is_expected.to eq embed_code }
      end

      describe "#title" do
        subject { super().title }
        it { is_expected.to eq "Deafheaven - 'New Bermuda' Trailer" }
      end

      describe "#description" do
        subject { super().description }
        description = "'New Bermuda,' the upcoming album from Deafheaven, " \
                      "is available October 2nd"
        it { is_expected.to eq description }
      end

      describe "#keywords" do
        subject { super().keywords }
        it "should return a string list of keywords" do
          keywords_list = []
          is_expected.to eq keywords_list
        end
      end

      describe "#duration" do
        subject { super().duration }
        it { is_expected.to eq 59 }
      end

      describe "#width" do
        subject { super().width }
        it { is_expected.to eq 1920 }
      end

      describe "#height" do
        subject { super().height }
        it { is_expected.to eq 1080 }
      end

      describe "#date" do
        subject { super().date }
        it "should have correct upload date" do
          is_expected.to eq Time.parse("2015-08-21T21:37:43+00:00",
            Time.now.utc).utc
        end
      end

      describe "#thumbnail_small" do
        subject { super().thumbnail_small }
        thumbnail_url = /i.vimeocdn.com\/video\/531688239-17d856b48d059b4c39ec5c94ea0ddc24ccf759d49173aadd900cf0f0fe50336d-d.*100x75.jpg/
        it { is_expected.to match thumbnail_url }
      end

      describe "#thumbnail_medium" do
        subject { super().thumbnail_medium }
        thumbnail_url = /i.vimeocdn.com\/video\/531688239-17d856b48d059b4c39ec5c94ea0ddc24ccf759d49173aadd900cf0f0fe50336d-d.*_200x150.jpg/
        it { is_expected.to match thumbnail_url }
      end

      describe "#thumbnail_large" do
        subject { super().thumbnail_large }
        thumbnail_url = /i.vimeocdn.com\/video\/531688239-17d856b48d059b4c39ec5c94ea0ddc24ccf759d49173aadd900cf0f0fe50336d-d.*_640.jpg/
        it { is_expected.to match thumbnail_url }
      end

      describe "#thumbnail_large_2x" do
        subject { super().thumbnail_large_2x }
        it { is_expected.to be_nil }
      end

      describe "#thumbnail_maxres" do
        subject { super().thumbnail_maxres }
        it { is_expected.to be_nil }
      end

      describe "#thumbnail" do
        subject { super().thumbnail }
        thumbnail_url = /i.vimeocdn.com\/video\/531688239-17d856b48d059b4c39ec5c94ea0ddc24ccf759d49173aadd900cf0f0fe50336d-d.*_640.jpg/
        it { is_expected.to match thumbnail_url }
      end

      describe "#author_thumbnail" do
        subject { super().author_thumbnail }

        #
        # For some reason, the scraper returns an image URL without
        # a file extension. This will likely change in the future.
        #

        thumbnail_url = "https://i.vimeocdn.com/portrait/14790276_75x75"

        if api_key
          thumbnail_url += ".jpg"
        end

        it { is_expected.to eq thumbnail_url }
      end

      describe "#author" do
        subject { super().author }
        it { is_expected.to eq "ANTI- Records" }
      end

      describe "#author_url" do
        subject { super().author_url }
        it { is_expected.to eq "https://vimeo.com/antirecords" }
      end

      describe "#view_count" do
        subject { super().view_count }
        it { is_expected.to be > 600 }
      end

      describe "#stats" do
        subject { super().stats.keys }
        it { is_expected.to match(api_key ? %w[plays] : %w[plays likes comments]) }
      end
    end

    context "with video 898029 and url_attributes" do
      subject { VideoInfo.new("http://www.vimeo.com/898029") }

      it "should add URL attribute" do
        attributes = {autoplay: 1}
        embed_code = subject.embed_code(url_attributes: attributes)
        expect(embed_code).to match(/autoplay=1/)
      end
    end

    context "with video 898029 and iframe_attributes" do
      subject { VideoInfo.new("http://www.vimeo.com/898029") }

      it "should have proper dimensions" do
        dimensions = {width: 800, height: 600}
        embed_code = subject.embed_code(iframe_attributes: dimensions)
        expect(embed_code).to match(/width="800"/)
        expect(embed_code).to match(/height="600"/)
      end
    end

    context "with video 898029 in /group/ url" do
      subject { VideoInfo.new("http://vimeo.com/groups/1234/videos/898029") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "Vimeo" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "898029" }
      end
    end

    context "with video 898029 in /group/ url" do
      subject { VideoInfo.new("http://player.vimeo.com/video/898029") }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "Vimeo" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "898029" }
      end
    end

    context "with video 898029 in text" do
      video_url_in_text = '<a href="http://www.vimeo.com/898029">' \
                          "http://www.vimeo.com/898029</a>"
      subject { VideoInfo.new(video_url_in_text) }

      describe "#provider" do
        subject { super().provider }
        it { is_expected.to eq "Vimeo" }
      end

      describe "#video_id" do
        subject { super().video_id }
        it { is_expected.to eq "898029" }
      end
    end

    context "with video 101677664 in /ondemand/ url" do
      subject { VideoInfo.new("https://vimeo.com/ondemand/less/101677664") }

      its(:provider) { should eq "Vimeo" }
      its(:video_id) { should eq "101677664" }
    end

    context "with video 111431415 in /channels/*/ url" do
      video_url = "https://vimeo.com/channels/some_channel1/111431415"
      subject { VideoInfo.new(video_url) }

      its(:provider) { should eq "Vimeo" }
      its(:video_id) { should eq "111431415" }
    end

    context "with video 126641548 in /user*/review/126641548/* url" do
      video_url = "http://www.vimeo.com/user39798190/review/126641548/8a56234e32"
      subject { VideoInfo.new(video_url) }

      its(:provider) { should eq "Vimeo" }
      its(:video_id) { should eq "126641548" }
    end

    context "with video 642263700" do
      video_url = "https://vimeo.com/642263700"
      subject { VideoInfo.new(video_url) }

      its(:thumbnail) { should match /i.vimeocdn.com\/video\/1291917478-2522170a8cfe68dc920e5031deac9bc5ff4d6699c96341fbe.*_640.jpg/ }
      its(:thumbnail_large) { should match /i.vimeocdn.com\/video\/1291917478-2522170a8cfe68dc920e5031deac9bc5ff4d6699c96341fbe.*_640.jpg/ }
      its(:thumbnail_medium) { should match /i.vimeocdn.com\/video\/1291917478-2522170a8cfe68dc920e5031deac9bc5ff4d6699c96341fbe.*_200x150.jpg/ }
      its(:thumbnail_small) { should match /i.vimeocdn.com\/video\/1291917478-2522170a8cfe68dc920e5031deac9bc5ff4d6699c96341fbe.*_100x75.jpg/ }
    end

    context "with unavailable video" do
      if api_key.nil?
        video_url = "https://vimeo.com/0812455"
        subject { VideoInfo.new(video_url) }

        its(:available?) { should be false }
        its(:author) { should be nil }
        its(:author_thumbnail) { should be nil }
        its(:author_url) { should be nil }
        its(:title) { should be nil }
        its(:description) { should be nil }
        its(:date) { should be nil }
        its(:duration) { should be nil }
        its(:keywords) { should be nil }
        its(:height) { should be nil }
        its(:width) { should be nil }
        its(:thumbnail_small) { should be nil }
        its(:thumbnail_medium) { should be nil }
        its(:thumbnail_large) { should be nil }
        its(:view_count) { should be nil }
      end
    end

    context "with video 7848846" do
      subject { VideoInfo.new("https://vimeo.com/7848846") }

      its(:stats) {
        if api_key
          should eq({
            "plays" => nil,
          })
        else
          should eq({
            "plays" => nil,
            "likes" => nil,
            "comments" => nil
          })
        end
      }
    end
  end
end
