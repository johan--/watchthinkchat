require 'spec_helper'

RSpec.describe Option, type: :model do
  it 'has a valid factory' do
    expect(create(:option)).to be_valid
  end
  it 'is invalid without a title' do
    expect(build(:option, title: nil)).not_to be_valid
  end
  it 'is invalid without a conditional' do
    expect(build(:option, conditional: nil)).not_to be_valid
  end
  it 'is invalid without a conditional_question if conditional is skip' do
    expect(build(:option,
                 conditional: :skip,
                 conditional_question: nil)).not_to be_valid
  end
  it 'is destroyed when question is destroyed' do
    @option = create(:option)
    @option.question.destroy!
    expect { @option.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'generates a unique code'
end
