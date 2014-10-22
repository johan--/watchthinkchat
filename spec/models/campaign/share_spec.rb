require 'rails_helper'

RSpec.describe Campaign::Share, type: :model do
  it 'is invalid without an enabled' do
    expect(build(:share, enabled: nil)).not_to be_valid
  end
  it 'is invalid without a campaign' do
    expect(build(:share, campaign: nil)).not_to be_valid
  end
  it { is_expected.to have_db_column(:facebook).of_type(:boolean).with_options(default: true) }
  it { is_expected.to have_db_column(:twitter).of_type(:boolean).with_options(default: true) }
  it { is_expected.to have_db_column(:email).of_type(:boolean).with_options(default: true) }
  it { is_expected.to have_db_column(:link).of_type(:boolean).with_options(default: true) }
end
