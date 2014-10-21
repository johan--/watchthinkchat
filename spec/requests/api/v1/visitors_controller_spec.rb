require 'rails_helper'

RSpec.describe Api::V1::VisitorsController, type: :request do
  let(:campaign) { create(:campaign) }

  before do
    get "http://api.#{ENV['base_url']}/token.js",
        referer: "http://#{campaign.url}/"
    @access_token = response.body[/\".*?\"/].gsub(/"/, '')
    @current_visitor = Visitor.first
  end

  describe 'GET /visitors' do
    it 'returns current visitor' do
      get "http://api.#{ENV['base_url']}/v1/visitor",
          { access_token: @access_token },
          referer: "http://#{campaign.url}/"
      expect(json_response.keys).to(
        eq %w(first_name last_name email share_token)
      )
      expect(response).to have_http_status :ok
    end
  end

  describe 'PUT /visitors' do
    it 'updates current visitor' do
      put "http://api.#{ENV['base_url']}/v1/visitor",
          { access_token: @access_token }.merge(visitor: attributes_for(:visitor)),
          referer: "http://#{campaign.url}/"
      expect(json_response.keys).to(
        eq %w(first_name last_name email share_token)
      )
      expect(response).to have_http_status :ok
    end
  end
end
