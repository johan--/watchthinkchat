require 'spec_helper'

RSpec.describe Campaign::GuidedPair, type: :model do
  it 'is invalid without an enabled' do
    expect(build(:guided_pair, enabled: nil)).not_to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:guided_pair, campaign: nil)).not_to be_valid
  end
  it 'returns default title if not present' do
    @guided_pair = create(:guided_pair, title: nil)
    expect(@guided_pair.title)
      .to eq(I18n.t :title, scope: [:models, :campaign, :guided_pair])
  end
  it 'returns default description if not present' do
    @guided_pair = create(:guided_pair, description: nil)
    expect(@guided_pair.description)
      .to eq(I18n.t :description, scope: [:models, :campaign, :guided_pair])
  end
end
