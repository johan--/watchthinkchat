require 'spec_helper'

RSpec.describe CampaignObserver, type: :observer do
  subject { CampaignObserver.instance }

  before do
    ENV['heroku_name'] = 'watchthinkchat-test'
    ENV['heroku_token'] = '1234'
    Campaign.observers.enable :campaign_observer
    VCR.insert_cassette 'models/campaign_observer'
  end
  describe 'when campaign' do
    context 'url exists on the heroku platform' do
      it 'has a validation error' do
        campaign = create(:campaign, url: 'campaign-validation-error.com')
        campaign.delete
        expect(build(:campaign,
                     url: 'campaign-validation-error.com')).not_to be_valid
        subject.send(:remove_domain_by_url,
                     'campaign-validation-error.com')
      end
    end
    context 'is created' do
      it 'fires callbacks' do
        expect(subject).to receive(:before_validation).and_call_original
        expect(subject).to receive(:after_validation).and_call_original
        campaign = create(:campaign, url: 'campaign-create-callback.com')
        campaign.destroy
      end
      it 'adds domain to heroku' do
        campaign_attributes =
          attributes_for(:campaign, url: 'add-a-domain.com')
        expect(subject.send(:domain_exists?,
                            campaign_attributes[:url])).to eq(false)
        campaign = create(:campaign, campaign_attributes)
        expect(subject.send(:domain_exists?,
                            campaign_attributes[:url])).to eq(true)
        campaign.destroy
      end
    end
    context 'is destroyed' do
      it 'fires callbacks' do
        expect(subject).to receive(:before_destroy).and_call_original
        campaign = create(:campaign, url: 'campaign-destroy-callback.com')
        campaign.destroy
      end
      it 'removes domain from heroku' do
        campaign = create(:campaign, url: 'remove-a-domain.com')
        expect(subject.send(:domain_exists?,
                            campaign.url)).to eq(true)
        campaign.destroy
        expect(subject.send(:domain_exists?,
                            campaign.url)).to eq(false)
      end
    end
  end
  after do
    VCR.eject_cassette
    Campaign.observers.disable :campaign_observer
  end
end
