require 'spec_helper'

RSpec.describe Campaign, type: :model do
  context 'when status is not setup' do
    it 'is invalid without a name' do
      expect(build(:campaign, name: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid without a locale' do
      expect(build(:campaign, locale: nil, status: :opened)).not_to be_valid
    end
  end
  it 'creates a translation object when name is set' do
    @campaign = create(:campaign)
    expect(@campaign.translations
      .where(field: :name, content: @campaign.name))
      .to exist
  end

end
