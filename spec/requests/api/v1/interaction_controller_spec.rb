require 'rails_helper'

RSpec.describe Api::V1::InteractionsController, type: :request do
  let(:campaign) { create(:campaign) }

  before do
    get "http://api.#{ENV['base_url']}/token.js",
        referer: "http://#{campaign.url}/"
    @access_token = response.body[/\".*?\"/].gsub(/"/, '')
  end
  describe 'POST /interaction' do
    context 'valid object' do
      it 'retuns newly created object' do
        expect do
          post "http://api.#{ENV['base_url']}/v1/interactions",
               { interaction: { resource_id: campaign.id,
                                resource_type: 'Campaign',
                                action: 'start' },
                 access_token: @access_token },
               referer: "http://#{campaign.url}/"
        end.to change(User::Visitor::Interaction, :count).by(1)
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
        end.to change(User::Visitor::Interaction, :count).by(1)
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
