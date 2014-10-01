require 'spec_helper'

describe Campaign::EngagementPlayerDecorator, type: :decorator do
  let(:code) { Faker::Code.ean }
  let(:engagement_player) { create(:engagement_player) }
  let(:engagement_player_decorator) { engagement_player.decorate }

  describe 'returns a youtube video id' do
    let(:code) { Faker::Code.ean }
    it 'when normal link' do
      engagement_player.update(
        media_link: "https://www.youtube.com/watch?v=#{code}")
      expect(engagement_player_decorator.youtube_video_id).to eq(code)
    end
    it 'when embed link' do
      engagement_player.update(
        media_link: "https://www.youtube.com/embed/#{code}")
      expect(engagement_player_decorator.youtube_video_id).to eq(code)
    end
    it 'when short link' do
      engagement_player.update(
        media_link: "https://youtu.be/#{code}")
      expect(engagement_player_decorator.youtube_video_id).to eq(code)
    end
    it 'unless link is not youtube' do
      engagement_player.update(
        media_link: "https://vimeo.com/#{code}")
      expect(engagement_player_decorator.youtube_video_id).to be_nil
    end
  end

end
