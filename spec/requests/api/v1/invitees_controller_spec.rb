require 'rails_helper'

RSpec.describe Api::V1::InviteesController, type: :request do
  let(:campaign) { create(:campaign) }

  before do
    get "http://api.#{ENV['base_url']}/token.js",
        referer: "http://#{campaign.url}/"
    @access_token = response.body[/\".*?\"/].gsub(/"/, '')
    @current_visitor = Visitor.first.as(:inviter)
  end
  describe 'GET /invitees' do
    it 'retuns a list of invitees' do
      @invitee = create(:invitee)
      create(:invitation,
             invitee: @invitee,
             inviter: @current_visitor,
             campaign_id: campaign.id)
      get "http://api.#{ENV['base_url']}/v1/invitees",
          { access_token: @access_token },
          referer: "http://#{campaign.url}/"
      expect(json_response.first.keys).to(
        eq %w(id first_name last_name email invite_token)
      )
      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /invitees' do
    it 'creates a new invitee' do
      expect do
        post "http://api.#{ENV['base_url']}/v1/invitees",
             { access_token: @access_token }.merge(invitee: attributes_for(:visitor)),
             referer: "http://#{campaign.url}/"
      end.to change(Visitor::Invitation, :count).by(1)
      expect(json_response.keys).to(
        eq %w(id first_name last_name email invite_token)
      )
      expect(response).to have_http_status :created
    end
  end

  describe 'GET /invitees/:id' do
    context 'valid id' do
      it 'returns an invitee' do
        @invitee = create(:invitee)
        create(:invitation,
               invitee: @invitee,
               inviter: @current_visitor,
               campaign_id: campaign.id)
        get "http://api.#{ENV['base_url']}/v1/invitees/#{@invitee.id}",
            { access_token: @access_token },
            referer: "http://#{campaign.url}/"
        expect(json_response.keys).to(
          eq %w(id first_name last_name email invite_token)
        )
        expect(response).to have_http_status :ok
      end
    end
    context 'invalid id' do
      it 'returns an error' do
        get "http://api.#{ENV['base_url']}/v1/invitees/10",
            { access_token: @access_token },
            referer: "http://#{campaign.url}/"
        expect(json_response.keys).to eq %w(errors)
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'PUT /invitees/:id' do
    it 'updates an exisiting invitee' do
      @invitee = create(:invitee)
      create(:invitation,
             invitee: @invitee,
             inviter: @current_visitor,
             campaign_id: campaign.id)
      put "http://api.#{ENV['base_url']}/v1/invitees/#{@invitee.id}",
          { access_token: @access_token }
            .merge(invitee: attributes_for(:invitee)),
          referer: "http://#{campaign.url}/"
      expect(json_response.keys).to(
        eq %w(id first_name last_name email invite_token)
      )
      expect(response).to have_http_status :ok
    end
  end
end
