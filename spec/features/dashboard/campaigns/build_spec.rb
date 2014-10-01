require 'spec_helper'

describe 'Campaign Builder', type: :feature, js: true do
  let(:manager) { create(:manager) }
  let(:base_locale) { create(:locale, name: 'base') }
  let(:available_locale) { create(:locale, name: 'available') }

  before do
    Warden.test_mode!
    Capybara.app_host = "http://app.#{ENV['base_url']}.lvh.me:7171"
    login_as(manager, scope: :user)
    base_locale.save!
    available_locale.save!
  end

  feature 'build campaign' do
    given(:campaign) { create(:campaign) }
    background do
      create(:permission,
             user: manager,
             state: Permission.states[:owner],
             resource: campaign)
    end
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
      expect(current_path).to eq(campaign_build_path(Campaign.last.id,
                                                     :engagement_player))
    end
    scenario 'engagement player page' do
      campaign.engagement_player!
      engagement_player_attributes = attributes_for(:engagement_player)
      visit campaign_build_path(campaign, :engagement_player)
      choose 'On'
      click_button 'Next'
      find '#campaign_engagement_player_attributes_media_link.error'
      fill_in 'campaign[engagement_player_attributes][media_link]',
              with: engagement_player_attributes[:media_link]
      fill_in 'campaign[engagement_player_attributes][media_start]',
              with: '0'
      fill_in 'campaign[engagement_player_attributes][media_stop]',
              with: '10'
      click_button 'Next'
      expect(current_path).to eq(campaign_build_path(campaign,
                                                     :survey))
    end
    scenario 'survey page' do
      campaign.survey!
      visit campaign_build_path(campaign, :survey)
      expect do
        wait_until_angular_ready
        fill_in 'new_question_title', with: 'Will you follow me?'
        fill_in 'new_option_text', with: 'Yes'
        select 'Continue', from: 'new_conditional'
        click_button 'Add Question'
        page
      end.to change(Campaign::Survey::Question, :count).by(1)
      click_button 'Next'
      expect(current_path).to eq(campaign_build_path(campaign,
                                                     :guided_pair))
    end
    scenario 'guided pair page' do
      campaign.guided_pair!
      guided_pair_attributes = attributes_for(:guided_pair)
      visit campaign_build_path(campaign, :guided_pair)
      choose 'On'
      fill_in 'campaign[guided_pair_attributes][title]',
              with: guided_pair_attributes[:title]
      fill_in 'campaign[guided_pair_attributes][description]',
              with: guided_pair_attributes[:description]
      click_button 'Next'
      expect(current_path).to eq(campaign_build_path(campaign,
                                                     :community))
    end
    scenario 'community page' do
      campaign.community!
      community_attributes = attributes_for(:community)
      visit campaign_build_path(campaign, :community)
      choose 'On'
      click_button 'Next'
      find '#campaign_community_attributes_other_campaign_input.error'
      choose 'Campaign'
      click_button 'Next'
      find '#campaign_community_attributes_child_campaign_input.error'
      choose 'URL'
      click_button 'Next'
      find '#campaign_community_attributes_url.error'
      fill_in 'campaign[community_attributes][url]',
              with: community_attributes[:url]
      find '#campaign_community_attributes_title.error'
      fill_in 'campaign[community_attributes][title]',
              with: community_attributes[:title]
      find '#campaign_community_attributes_description.error'
      fill_in 'campaign[community_attributes][description]',
              with: community_attributes[:description]
      click_button 'Next'
      expect(current_path).to eq(campaign_build_path(campaign,
                                                     :opened))
    end
  end

  after do
    Warden.test_reset!
  end
end
