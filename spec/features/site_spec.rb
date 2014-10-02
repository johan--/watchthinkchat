require 'rails_helper'

describe 'Site', type: :feature, js: true do
  feature 'cname' do
    let(:campaign) { create(:campaign) }
    before do
      Capybara.app_host = "http://#{campaign.url}.lvh.me:7171"
    end
    describe 'create visitor object' do
      subject { -> { visit root_path } }
      it { is_expected.to change(User, :count).by(1) }
      it { is_expected.to change(Permission, :count).by(1) }
    end
    scenario 'visitor comes to root_path' do
      visit root_path
      expect(evaluate_script('campaign')).to(
        eq(JSON.parse(Rabl::Renderer.json(campaign,
                                          'site/campaign',
                                          view_path: 'app/views')))
        )
    end
  end

  feature 'subdomain' do
    let(:campaign) { create(:subdomain_campaign) }
    before do
      Capybara.app_host =
        "http://#{campaign.url}.#{ENV['base_url']}.lvh.me:7171"
    end
    scenario 'visitor comes to root_path' do
      visit root_path
      expect(evaluate_script('campaign')).to(
        eq(JSON.parse(Rabl::Renderer.json(campaign,
                                          'site/campaign',
                                          view_path: 'app/views')))
        )
    end
  end
end
