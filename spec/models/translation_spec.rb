require 'rails_helper'

RSpec.describe Translation, type: :model do
  # associations
  it { is_expected.to belong_to(:campaign) }
  it { is_expected.to belong_to(:resource) }
  it { is_expected.to belong_to(:locale) }

  # validations
  it 'is invalid without resource' do
    expect(build(:translation, resource: nil)).not_to be_valid
  end
  it 'is invalid without locale when base is false' do
    expect(build(:translation, locale: nil, base: false)).not_to be_valid
  end
  it 'is not invalid without locale when base is true' do
    expect(build(:translation, locale: nil, base: true)).to be_valid
  end

  # parent objects
  describe 'is destroyed when' do
    it 'campaign is destroyed' do
      @translation = create(:translation)
      @translation.campaign.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'resource campaign is destroyed' do
      @translation = create(:campaign_translation)
      @translation.resource.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'resource question is destroyed' do
      @translation = create(:question_translation)
      @translation.resource.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'resource option is destroyed' do
      @translation = create(:option_translation)
      @translation.resource.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'resource engagement player is destroyed' do
      @translation = create(:engagement_player_translation)
      @translation.resource.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'locale is destroyed' do
      @translation = create(:locale_translation)
      @translation.locale.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
