require 'spec_helper'

describe Campaign::EngagementPlayer::OptionDecorator, type: :decorator do
  let(:option) { create(:option) }
  let(:option_decorator) { option.decorate }

  it 'returns a permalink' do
    expect(option_decorator.permalink
      ).to eq("#{option.campaign.decorate.permalink}/#/o/#{option.code}")
  end
end
