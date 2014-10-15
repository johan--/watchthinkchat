require 'rails_helper'

RSpec.describe User::Visitor::Interaction, type: :model do
  subject { create(:interaction) }
  # associations
  it { is_expected.to belong_to(:campaign) }
  it { is_expected.to have_db_index(:campaign_id) }
  it { is_expected.to belong_to(:resource) }
  it { is_expected.to have_db_index(:resource_id) }
  it { is_expected.to belong_to(:visitor) }
  it { is_expected.to have_db_index(:visitor_id) }

  # validations
  it { is_expected.to validate_presence_of(:campaign) }
  it { is_expected.to validate_presence_of(:resource) }
  it { is_expected.to validate_presence_of(:visitor) }
  it { is_expected.to validate_presence_of(:action) }

  # definitions
  it do
    is_expected.to define_enum_for(:action).with([:start,
                                                  :finish])
  end
  it { is_expected.to serialize(:data) }
  it 'only allows interactions where resources are related to campaigns' do
    @interaction = build(:interaction)
    @interaction.resource = create(:campaign)
    expect(@interaction).to_not be_valid
  end
end
