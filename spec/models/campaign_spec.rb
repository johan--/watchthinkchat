require 'spec_helper'

RSpec.describe Campaign, type: :model do
  # associations
  it { is_expected.to have_many(:permissions).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:permissions) }
  it do
    is_expected.to have_many(:translation_groups).class_name('Translation')
                                                 .dependent(:destroy)
  end
  it { is_expected.to have_many(:translations).dependent(:destroy) }
  it { is_expected.to have_many(:available_locales) }
  it { is_expected.to have_many(:locales).through(:available_locales) }
  it { is_expected.to have_one :engagement_player }
  it { is_expected.to belong_to :locale }
  it { is_expected.to accept_nested_attributes_for :engagement_player }

  # validations
  context 'when status is not setup' do
    it 'is invalid without a name' do
      expect(build(:campaign, name: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid without a locale' do
      expect(build(:campaign, locale: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid without a cname' do
      expect(build(:campaign, cname: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid when cname is not unique' do
      @campaign = create(:campaign)
      expect(build(:campaign,
                   cname: @campaign.cname,
                   status: :opened)).not_to be_valid
    end
  end

  # callbacks
  context 'after create' do
    let(:campaign) { create(:campaign, status: nil) }
    it 'after create sets status to setup' do
      expect(campaign.setup?).to eq(true)
    end
  end

  # definitions
  context 'after create' do
    let(:campaign) { create(:campaign, status: nil) }
    it 'creates a translation object when name is set' do
      expect(campaign.translations
        .where(field: :name, content: campaign.name))
        .to exist
    end
    it '#campaign returns self' do
      expect(campaign.campaign).to eq(campaign)
    end
  end
end
