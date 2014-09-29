require 'spec_helper'

RSpec.describe Campaign::Community, type: :model do
  it { is_expected.to belong_to :campaign }
  it 'is invalid without a campaign' do
    expect(build(:community, campaign: nil)).not_to be_valid
  end
  it 'is invalid without an enabled' do
    expect(build(:community, enabled: nil)).not_to be_valid
  end
  it 'is invalid without an other_campaign' do
    expect(build(:community, other_campaign: nil)).not_to be_valid
  end
  describe 'when other_campaign' do
    context 'is true' do
      it 'is invalid without child_campaign' do
        expect(build(:community_other_campaign,
                     child_campaign: nil,
                     other_campaign: true)).not_to be_valid
      end
      it 'retrieves child_camapaign as permalink' do
        @community = create(:community_other_campaign)
        expect(@community.permalink).to eq(@community.child_campaign.permalink)
      end
      it 'retrieves display_title as campaign.name' do
        @community = create(:community_other_campaign)
        expect(@community.display_title).to eq(@community.child_campaign.name)
      end
    end
    context 'is false' do
      it 'is invalid without a url' do
        expect(build(:community,
                     url: nil,
                     other_campaign: false)).not_to be_valid
      end
      it { is_expected.to ensure_length_of(:url).is_at_most(255) }
      it do
        is_expected.to_not allow_value('goober',
                                       '-',
                                       'google.com/path').for(:url)
      end
      it do
        is_expected.to allow_value('http://www.goober.com',
                                   'http://subdomain.example.com/rails',
                                   'https://mail.google.com/12/23/4/79?q=t',
                                   'http://valid.domain.museum/greg').for(:url)
      end
      it 'is invalid without a description' do
        expect(build(:community,
                     description: nil,
                     other_campaign: false)).not_to be_valid
      end
      it 'is invalid without a title' do
        expect(build(:community,
                     title: nil,
                     other_campaign: false)).not_to be_valid
      end
      it 'retrieves url as permalink' do
        @community = create(:community)
        expect(@community.permalink).to eq(@community.url)
      end
      it 'retrieves display_title as title' do
        @community = create(:community)
        expect(@community.display_title).to eq(@community.title)
      end
    end
  end
  it 'creates a translation object when title is set' do
    @community = create(:community)
    expect(
      @community.translations.where(field: :title,
                                    content: @community.title)
    ).to exist
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
end
