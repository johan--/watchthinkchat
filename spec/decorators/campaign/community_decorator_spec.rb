require 'rails_helper'

describe Campaign::CommunityDecorator, type: :decorator do
  describe 'when other_campaign' do
    context 'is true' do
      let(:community) { create(:community_other_campaign) }
      let(:community_decorator) { community.decorate }

      it 'retrieves child_camapaign as permalink' do
        expect(community_decorator.permalink)
          .to eq(community.child_campaign.decorate.permalink)
      end
      it 'retrieves display_title as campaign.name' do
        expect(community_decorator.display_title)
          .to eq(community.child_campaign.name)
      end
    end
    context 'is false' do
      let(:community) { create(:community) }
      let(:community_decorator) { community.decorate }

      it 'retrieves url as permalink' do
        expect(community_decorator.permalink).to eq(community.url)
      end
      it 'retrieves display_title as title' do
        expect(community_decorator.display_title).to eq(community.title)
      end
    end
  end
end
