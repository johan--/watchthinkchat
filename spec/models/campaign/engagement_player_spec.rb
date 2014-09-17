require 'spec_helper'

RSpec.describe Campaign::EngagementPlayer, type: :model do
  it 'is invalid without a media link' do
    expect(build(:engagement_player, media_link: nil)).not_to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:engagement_player, campaign: nil)).not_to be_valid
  end
  it 'is invalid without a survey on update' do
    @engagement_player = create(:engagement_player)
    @engagement_player.survey = nil
    expect(@engagement_player).not_to be_valid
  end
  it 'creates a translation object when media_link is set' do
    @engagement_player = create(:engagement_player)
    expect(@engagement_player.translations
      .where(field: :media_link, content: @engagement_player.media_link))
      .to exist
  end
  describe 'returns a youtube video id' do
    let(:code) { Faker::Code.ean }
    it 'when normal link' do
      @engagement_player =
        create(:engagement_player,
               media_link: "https://www.youtube.com/watch?v=#{code}")
      expect(@engagement_player.youtube_video_id).to eq(code)
    end
    it 'when embed link' do
      @engagement_player =
        create(:engagement_player,
               media_link: "https://www.youtube.com/embed/#{code}")
      expect(@engagement_player.youtube_video_id).to eq(code)
    end
    it 'when short link' do
      @engagement_player =
        create(:engagement_player,
               media_link: "https://youtu.be/#{code}")
      expect(@engagement_player.youtube_video_id).to eq(code)
    end
    it 'unless link is not youtube' do
      @engagement_player =
        create(:engagement_player,
               media_link: "https://vimeo.com/#{code}")
      expect(@engagement_player.youtube_video_id).to be_nil
    end
  end
end
