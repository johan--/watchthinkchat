require 'spec_helper'

describe UserDecorator, type: :decorator do
  let(:available_locale) { create(:available_locale).decorate }

  it '#permissions returns array of permissions for this locale' do
    @user = create(:user)
    @permission = Permission.create(resource: available_locale.campaign,
                                    locale: available_locale.locale,
                                    state: Permission.states[:translator],
                                    user: @user)
    expect(available_locale.permissions.first).to eq(@permission)
  end

  it '#completion returns percentage of terms translated for this locale' do
    expect(available_locale.completion).to eq(0)
    @base_translation = Translation.first
    Translation.create(resource: available_locale.campaign,
                       campaign: available_locale.campaign,
                       locale: available_locale.locale,
                       field: @base_translation.field,
                       content: @base_translation.content)
    expect(available_locale.completion).to eq(100)
  end
end
