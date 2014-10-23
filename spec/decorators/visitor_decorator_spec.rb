require 'rails_helper'

describe VisitorDecorator, type: :decorator do
  let(:campaign) { create(:campaign).decorate }
  let(:visitor) { create(:visitor).decorate }

  describe '.name' do
    it 'returns full name' do
      expect(visitor.name).to eq("#{visitor.first_name} #{visitor.last_name}".strip)
    end
  end

  describe '.share_url' do
    it 'returns full url' do
      expect(visitor.url(campaign)).to eq("#{campaign.permalink}/i/#{visitor.share_token}")
    end
  end
end
