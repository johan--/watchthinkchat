require 'rails_helper'

RSpec.describe Visitor, type: :model do
  # associations
  it { is_expected.to have_many(:interactions).dependent(:destroy) }
  it { is_expected.to have_many(:invitees).dependent(:nullify) }
  it { is_expected.to have_one(:inviter) }
  it { is_expected.to have_db_column(:inviter_id) }
  it { is_expected.to have_db_index(:inviter_id) }
  it { is_expected.to have_db_column(:invite_token) }
  it { is_expected.to have_db_index(:invite_token) }
  it { is_expected.to have_db_column(:share_token) }
  it { is_expected.to have_db_index(:share_token) }
  it { is_expected.to have_db_column(:authentication_token) }
  it { is_expected.to have_db_index(:authentication_token) }
end
