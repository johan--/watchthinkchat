require 'spec_helper'

describe Campaign::GuidedPairDecorator, type: :decorator do
  let(:guided_pair) do
    create(:guided_pair, title: '', description: '').decorate
  end

  it 'returns default title if not present' do
    expect(guided_pair.title)
      .to eq(I18n.t :title, scope: [:models, :campaign, :guided_pair])
  end
  it 'returns default description if not present' do
    expect(guided_pair.description)
      .to eq(I18n.t :description, scope: [:models, :campaign, :guided_pair])
  end
end
