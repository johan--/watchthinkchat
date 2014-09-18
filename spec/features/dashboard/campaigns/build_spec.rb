require 'spec_helper'

describe 'Campaign Builder', type: :feature do
  let(:manager) { create(:manager) }
  let(:base_locale) { create(:locale) }
  let(:available_locale) { create(:locale) }

  before do
    Warden.test_mode!
    Capybara.app_host = "http://#{ENV['dashboard_url']}"
    login_as(manager, scope: :user)
    base_locale.save!
    available_locale.save!
  end

  feature 'build campaign' do
    scenario 'basic page' do
      expect { visit new_campaign_path }.to change(Campaign, :count).by(1)
      campaign_attributes = attributes_for(:campaign)
      click_button 'Next'
      find '#campaign_name_input.has-error'
      find '#campaign_locale_input.has-error'
      find '#campaign_url_input.has-error'
      fill_in 'campaign[name]', with: campaign_attributes[:name]
      select base_locale.name, from: 'campaign[locale_id]'
      select available_locale.name, from: 'campaign[locale_ids][]'
      fill_in 'campaign[url]', with: campaign_attributes[:url]
      choose 'CNAME Address'
      click_button 'Next'
      expect(current_path).to eq(campaign_build_path(Campaign.first.id,
                                                     :engagement_player))
    end
  end

  after do
    Warden.test_reset!
  end
end
