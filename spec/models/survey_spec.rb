require 'spec_helper'

RSpec.describe Survey, type: :model do
  it 'has a valid factory' do
    expect(create(:survey)).to be_valid
  end
  it 'is invalid without engagement player' do
    expect(build(:survey, engagement_player: nil)).not_to be_valid
  end
  it 'is destroyed when engagement player is destroyed' do
    @survey = create(:survey)
    @survey.engagement_player.destroy!
    expect { @survey.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
