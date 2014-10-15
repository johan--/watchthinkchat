require 'rails_helper'

describe CampaignDecorator, type: :decorator do

  describe '#permalink' do
    context 'url is a cname' do
      let(:campaign) { create(:campaign) }
      let(:campaign_decorator) { campaign.decorate }
      it 'returns a url' do
        expect(campaign_decorator.permalink).to(
          eq("http://#{campaign.url}"))
      end
    end
    context 'url is a subdomain' do
      let(:campaign) { create(:subdomain_campaign) }
      let(:campaign_decorator) { campaign.decorate }
      it 'returns a url' do
        expect(campaign_decorator.permalink).to(
          eq("http://#{campaign.url}.#{ENV['base_url']}"))
      end
    end
  end
end
