require 'spec_helper'

RSpec.describe EngagementPlayer, type: :model do
  it 'has a valid factory' do
    expect(create(:engagement_player)).to be_valid
  end
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
end
