require 'rails_helper'

RSpec.describe Campaign::GuidedPair, type: :model do
  it 'is invalid without an enabled' do
    expect(build(:guided_pair, enabled: nil)).not_to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:guided_pair, campaign: nil)).not_to be_valid
  end
end
