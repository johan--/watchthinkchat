require 'spec_helper'

describe Campaign::EngagementPlayer::QuestionDecorator, type: :decorator do
  let(:question) { create(:question) }
  let(:question_decorator) { question.decorate }

  it 'returns a permalink' do
    expect(question_decorator.permalink
      ).to eq("#{question.campaign.decorate.permalink}/#/q/#{question.code}")
  end
end
