require 'rails_helper'

RSpec.describe Campaign::Share, type: :model do
  it 'is invalid without an enabled' do
    expect(build(:share, enabled: nil)).not_to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:share, campaign: nil)).not_to be_valid
  end
end
