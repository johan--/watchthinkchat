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

  # definitions
  it '#permissions returns array of permissions for this locale' do
    @available_locale = create(:available_locale)
    @user = create(:user)
    @permission = Permission.create(resource: @available_locale.campaign,
                                    locale: @available_locale.locale,
                                    state: Permission.states[:translator],
                                    user: @user)
    expect(@available_locale.permissions.first).to eq(@permission)
  end

  it '#completion returns percentage of terms translated for this locale' do
    @available_locale = create(:available_locale)
    expect(@available_locale.completion).to eq(0)
    @base_translation = Translation.first
    Translation.create(resource: @available_locale.campaign,
                       campaign: @available_locale.campaign,
                       locale: @available_locale.locale,
                       field: @base_translation.field,
                       content: @base_translation.content)
    expect(@available_locale.completion).to eq(100)
  end
end
