require 'rails_helper'

RSpec.describe Visitor::Invitee, type: :model do
  # associations
  it { is_expected.to have_many(:invitations) }
  it { is_expected.to have_db_column(:notify_inviter).of_type(:boolean) }
  it { is_expected.to have_many(:inviters).through(:invitations) }
end
