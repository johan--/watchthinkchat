require 'rails_helper'

RSpec.describe Visitor, type: :model do
  # associations
  it { is_expected.to have_many(:interactions).dependent(:destroy) }
end
