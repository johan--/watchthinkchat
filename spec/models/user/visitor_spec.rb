require 'rails_helper'

RSpec.describe User::Visitor, type: :model do
  # associations
  it { is_expected.to have_many(:interactions).dependent(:destroy) }
end
