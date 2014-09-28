require 'spec_helper'

RSpec.describe Campaign::Community, type: :model do
  it { is_expected.to belong_to :campaign }
  it 'is invalid without a campaign' do
    expect(build(:community, campaign: nil)).not_to be_valid
  end
  describe 'when other_campaign' do
    context 'is true' do
      it 'is invalid without child_campaign' do
        expect(build(:community_other_campaign,
                     child_campaign: nil,
                     other_campaign: true)).not_to be_valid
      end
    end
    context 'is false' do
      it 'is invalid without a url' do
        expect(build(:community,
                     url: nil,
                     other_campaign: false)).not_to be_valid
      end
      it 'is invalid without a description' do
        expect(build(:community,
                     description: nil,
                     other_campaign: false)).not_to be_valid
      end
    end
  end
  it 'creates a translation object when url is set' do
    @community = create(:community)
    expect(
      @community.translations.where(field: :url,
                                    content: @community.url)
    ).to exist
  end
  it 'creates a translation object when description is set' do
    @community = create(:community)
    expect(
      @community.translations.where(field: :description,
                                    content: @community.description)
    ).to exist
  end
  it 'is destroyed when campaign is destroyed' do
    @community = create(:community)
    @community.campaign.destroy!
    expect { @community.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
