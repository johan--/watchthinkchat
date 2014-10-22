require 'rails_helper'

RSpec.describe Api::V1::InteractionsController, type: :request do
  let(:campaign) { create(:campaign) }
  let(:engagement_player) { create(:engagement_player, campaign: campaign) }

  before do
    get "http://api.#{ENV['base_url']}/token.js",
        referer: "http://#{campaign.url}/"
    @access_token = response.body[/\".*?\"/].gsub(/"/, '')
  end

  describe Api::V1::InteractionsController::InteractionParams do
    describe '.permit' do
      it 'returns the cleaned params' do
        interaction_params = attributes_for(:interaction)
        params = ActionController::Parameters.new(interaction: { random: 'value' }.merge(interaction_params))
        permitted_params = Api::V1::InteractionsController::InteractionParams.permit(params)
        expect(permitted_params).to eq(interaction_params.with_indifferent_access)
      end
    end
  end

  describe 'POST /interaction' do
    context 'valid object' do
      it 'retuns newly created object' do
        expect do
          post "http://api.#{ENV['base_url']}/v1/interactions",
               { interaction: { resource_id: engagement_player.id,
                                resource_type: 'Campaign::EngagementPlayer',
                                action: 'start' },
                 access_token: @access_token },
               referer: "http://#{campaign.url}/"
        end.to change(Visitor::Interaction, :count).by(1)
        expect(response).to have_http_status :created
      end
      it 'stores one object and updates data' do
        expect do
          post "http://api.#{ENV['base_url']}/v1/interactions",
               { interaction: { resource_id: campaign.id,
                                resource_type: 'Campaign',
                                action: 'start' },
                 access_token: @access_token },
               referer: "http://#{campaign.url}/"
          post "http://api.#{ENV['base_url']}/v1/interactions",
               { interaction: { resource_id: campaign.id,
                                resource_type: 'Campaign',
                                action: 'start' },
                 access_token: @access_token },
               referer: "http://#{campaign.url}/"
        end.to change(Visitor::Interaction, :count).by(1)
        expect(response).to have_http_status :ok
      end
    end
    context 'invalid action parameter' do
      it 'returns error message' do
        post "http://api.#{ENV['base_url']}/v1/interactions",
             { interaction: { action: 'qwertyuiop' },
               access_token: @access_token },
             referer: "http://#{campaign.url}/"
        expect(response).to have_http_status :unprocessable_entity
        expect(json_response['errors']).to_not be_nil
      end
    end
    context 'invalid object' do
      it 'returns error message' do
        post "http://api.#{ENV['base_url']}/v1/interactions",
             { interaction: { action: 'start' },
               access_token: @access_token },
             referer: "http://#{campaign.url}/"
        expect(response).to have_http_status :unprocessable_entity
        expect(json_response['errors']).to_not be_nil
      end
    end
  end
end
