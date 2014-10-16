require 'rails_helper'

RSpec.describe Visitor, type: :model do
  # associations
  it { is_expected.to have_many(:interactions).dependent(:destroy) }
  it { is_expected.to have_db_column(:share_token) }
  it { is_expected.to have_db_index(:share_token) }
  it { is_expected.to have_db_column(:authentication_token) }
  it { is_expected.to have_db_index(:authentication_token) }
  # definitions
  describe '#as' do
    let(:visitor) { create(:visitor) }
    context ':inviter' do
      it 'returns inviter object' do
        expect(visitor.as(:inviter)).to be_a(Visitor::Inviter)
      end
    end
    context ':invitee' do
      it 'returns invitee object' do
        expect(visitor.as(:invitee)).to be_a(Visitor::Invitee)
      end
    end
  end
end
