require 'spec_helper'

RSpec.describe AvailableLocale, type: :model do
  it 'has a valid factory' do
    expect(create(:available_locale)).to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:available_locale, campaign: nil)).not_to be_valid
  end
  it 'is invalid without a locale' do
    expect(build(:available_locale, locale: nil)).not_to be_valid
  end
  it 'is destroyed when campaign is destroyed' do
    @available_locale = create(:available_locale)
    @available_locale.campaign.destroy!
    expect { @available_locale.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'is destroyed when locale is destroyed' do
    @available_locale = create(:available_locale)
    @available_locale.locale.destroy!
    expect { @available_locale.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
