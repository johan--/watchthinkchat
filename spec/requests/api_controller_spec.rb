require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let(:campaign) { create(:campaign) }

  describe 'token' do
    context 'arbitrary visitor' do
      it 'returns access token' do
        expect do
          get "http://api.#{ENV['base_url']}/token.js",
              referer: "http://#{campaign.url}/"
        end.to change(Visitor, :count).by(1)
        expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
          eq(Visitor.first.authentication_token))
      end
    end
  end
end
