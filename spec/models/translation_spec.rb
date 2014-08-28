require 'spec_helper'

RSpec.describe Translation, type: :model do
  it 'has a valid factory' do
    expect(create(:translation)).to be_valid
  end
  it 'is invalid without resource' do
    expect(build(:translation, resource: nil)).not_to be_valid
  end
  it 'is invalid without campaign' do
    expect(build(:translation, campaign: nil)).not_to be_valid
  end
  it 'is invalid without locale' do
    expect(build(:translation, locale: nil)).not_to be_valid
  end
  it 'is invalid without content' do
    expect(build(:translation, content: nil)).not_to be_valid
  end
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
      @translation = create(:translation)
      @translation.locale.destroy!
      expect { @translation.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
