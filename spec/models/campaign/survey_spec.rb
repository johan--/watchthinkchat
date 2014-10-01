require 'spec_helper'

RSpec.describe Campaign::Survey, type: :model do
  it 'is invalid without an enabled' do
    expect(build(:survey, enabled: nil)).not_to be_valid
  end
  it 'is invalid without campaign' do
    expect(build(:survey, campaign: nil)).not_to be_valid
  end
end
