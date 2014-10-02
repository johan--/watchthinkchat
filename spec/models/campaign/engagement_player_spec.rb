require 'spec_helper'

RSpec.describe Campaign::EngagementPlayer, type: :model do
  it 'is invalid without an enabled' do
    expect(build(:engagement_player, enabled: nil)).not_to be_valid
  end
  it 'is invalid without a media link' do
    expect(build(:engagement_player, media_link: nil)).not_to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:engagement_player, campaign: nil)).not_to be_valid
  end
  it 'creates a translation object when media_link is set' do
    @engagement_player = create(:engagement_player)
    expect(@engagement_player.translations
      .where(field: :media_link, content: @engagement_player.media_link))
      .to exist
  end
end
