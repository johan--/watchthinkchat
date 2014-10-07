require 'rails_helper'

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
  it { is_expected.to have_one(:engagement_player).validate(true) }
  it { is_expected.to have_one(:survey).validate(true) }
  it { is_expected.to have_one(:community).validate(true) }
  it { is_expected.to have_one(:guided_pair).validate(true) }
  it do
    is_expected.to(
      accept_nested_attributes_for(:engagement_player).update_only(true))
  end
  it do
    is_expected.to(
      accept_nested_attributes_for(:survey).update_only(true))
  end
  it do
    is_expected.to(
      accept_nested_attributes_for(:community).update_only(true))
  end
  it do
    is_expected.to(
      accept_nested_attributes_for(:guided_pair).update_only(true))
  end
  it { is_expected.to belong_to :locale }

  # validations
  context 'when status is opened' do
    it 'is invalid without a name' do
      expect(build(:campaign, name: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid without a locale' do
      expect(build(:campaign, locale: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid without a url' do
      expect(build(:campaign, url: nil, status: :opened)).not_to be_valid
    end
    it 'is invalid when url is not unique' do
      @campaign = create(:campaign)
      expect(build(:campaign,
                   url: @campaign.url,
                   status: :opened)).not_to be_valid
    end
  end
  describe 'when url is a subdomain' do
    before { subject.subdomain = true }
    it { is_expected.to ensure_length_of(:url).is_at_most(63) }
    it { is_expected.to_not allow_value('-gwtbesr-', '!@#$%').for(:url) }
    it { is_expected.to_not allow_value('app').for(:url) }
    it { is_expected.to allow_value('web', 'test', 'falling-plates').for(:url) }
  end

  describe 'when url is a cname' do
    before { subject.subdomain = false }
    it { is_expected.to ensure_length_of(:url).is_at_most(255) }
    it do
      is_expected.to_not allow_value('goober',
                                     '-',
                                     'http://google.com',
                                     'google.com/path').for(:url)
    end
    it do
      is_expected.to allow_value('goober.com',
                                 'subdomain.example.com',
                                 'mail.google.com',
                                 'valid.domain.museum').for(:url)
    end
  end

  # callbacks
  context 'after create' do
    let(:campaign) { create(:campaign) }
    it 'after create should set survey object' do
      expect(campaign.survey).to_not be_nil
    end
  end

  # definitions
  context 'after create' do
    let(:campaign) { create(:campaign, status: :basic) }
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
