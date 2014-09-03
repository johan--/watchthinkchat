require 'spec_helper'

describe Dashboard::CampaignsController do

  let(:manager) { create(:manager) }
  before do
    sign_in(manager)
    @campaign = create(:campaign)
    manager.campaigns << @campaign
    @survey = create(:engagement_player, campaign: @campaign).survey
    (0..1).each { |_n| create(:question, survey: @survey) }
  end

  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

end
