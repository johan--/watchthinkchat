require 'spec_helper'

RSpec.describe Campaign, type: :model do
  it 'has a valid factory' do
    expect(create(:campaign)).to be_valid
  end
  context 'when status is not setup' do
    it 'is invalid without a name' do
      expect(build(:campaign, name: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid without a locale' do
      expect(build(:campaign, locale: nil, status: :opened)).not_to be_valid
    end
  end

end
