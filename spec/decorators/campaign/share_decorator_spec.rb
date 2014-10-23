require 'rails_helper'

describe Campaign::ShareDecorator, type: :decorator do
  let(:share) do
    create(:share, title: '', description: '', subject: '', message: '').decorate
  end

  it 'returns default title if not present' do
    expect(share.title)
      .to eq(I18n.t :title, scope: [:models, :campaign, :share])
  end
  it 'returns default description if not present' do
    expect(share.description)
      .to eq(I18n.t :description, scope: [:models, :campaign, :share])
  end
  it 'returns default subject if not present' do
    expect(share.subject)
      .to eq(I18n.t :subject, scope: [:models, :campaign, :share])
  end
  it 'returns default message if not present' do
    expect(share.message)
      .to eq(I18n.t :message, scope: [:models, :campaign, :share])
  end
end
