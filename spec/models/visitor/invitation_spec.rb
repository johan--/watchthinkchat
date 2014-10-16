require 'rails_helper'

RSpec.describe Visitor::Invitation, type: :model do
  # associations
  it { is_expected.to belong_to(:campaign) }
  it { is_expected.to belong_to(:invitee) }
  it { is_expected.to belong_to(:inviter) }
  it { is_expected.to validate_presence_of(:inviter) }
  it { is_expected.to validate_presence_of(:invitee) }
  it { is_expected.to validate_presence_of(:campaign) }
  # definitions
  it 'generates token' do
    expect(create(:invitation).token).not_to be_nil
  end
end
