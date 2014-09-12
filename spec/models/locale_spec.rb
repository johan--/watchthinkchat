require 'spec_helper'

RSpec.describe Locale, type: :model do
  it 'is invalid without code' do
    expect(build(:locale, code: nil)).not_to be_valid
  end
  it 'is invalid without name' do
    expect(build(:locale, name: nil)).not_to be_valid
  end
end
