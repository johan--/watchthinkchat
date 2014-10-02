require 'spec_helper'

RSpec.describe User::Manager, type: :model do
  # validations
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_confirmation_of(:password).on(:create) }
end
