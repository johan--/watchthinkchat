require 'spec_helper'

RSpec.describe Question, type: :model do
  it 'has a valid factory' do
    expect(create(:question)).to be_valid
  end
  it 'is invalid without survey' do
    expect(build(:question, survey: nil)).not_to be_valid
  end
  it 'is invalid without title' do
    expect(build(:question, title: nil)).not_to be_valid
  end
  it 'is destroyed when survey is destroyed' do
    @question = create(:question)
    @question.survey.destroy!
    expect { @question.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'generates a unique code' do
    @question = create(:question)
    expect(@question.code).to eq(Base62.encode(@question.id))
  end
end
