require 'spec_helper'

RSpec.describe AvailableLocale, type: :model do
  # associations
  it { is_expected.to belong_to :campaign }
  it { is_expected.to belong_to :locale }

  # validations
  it { is_expected.to validate_presence_of :campaign }
  it { is_expected.to validate_presence_of :locale }

  # parent objects
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
