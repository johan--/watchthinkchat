require 'rails_helper'

RSpec.describe Api::V1::Invitees::EmailsController, type: :request do
  let(:campaign) { create(:campaign) }

  before do
    get "http://api.#{ENV['base_url']}/token.js",
        referer: "http://#{campaign.url}/"
    @access_token = response.body[/\".*?\"/].gsub(/"/, '')
    @current_visitor = Visitor.first.as(:inviter)
  end

  describe Api::V1::Invitees::EmailsController::EmailParams do
    describe '.permit' do
      it 'returns the cleaned params' do
        email_params = attributes_for(:invitee_email)
        params = ActionController::Parameters.new(email: { random: 'value' }.merge(email_params))
        permitted_params = Api::V1::Invitees::EmailsController::EmailParams.permit(params)
        expect(permitted_params).to eq(email_params.with_indifferent_access)
      end
    end
  end

  describe 'POST /emails' do
    it 'sends an email to an invitee' do
      put "http://api.#{ENV['base_url']}/v1/visitor",
          { access_token: @access_token }.merge(visitor: attributes_for(:visitor)),
          referer: "http://#{campaign.url}/"
      post "http://api.#{ENV['base_url']}/v1/invitees",
           { access_token: @access_token }.merge(invitee: attributes_for(:visitor)),
           referer: "http://#{campaign.url}/"
      expect do
        post "http://api.#{ENV['base_url']}/v1/invitees/#{JSON.parse(response.body)['id']}/emails",
             { access_token: @access_token }.merge(email: attributes_for(:invitee_email)),
             referer: "http://#{campaign.url}/"
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(json_response.keys).to(
        eq %w(to from subject message)
      )
      expect(response).to have_http_status :created
    end
  end
end
