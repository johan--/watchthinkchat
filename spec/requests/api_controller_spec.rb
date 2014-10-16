require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let(:campaign) { create(:campaign) }

  describe 'token' do
    context 'visitor from unknown' do
      it 'returns access token' do
        expect do
          get "http://api.#{ENV['base_url']}/token.js",
              {},
              referer: "http://#{campaign.url}/"
        end.to change(Visitor, :count).by(1)
        expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
          eq(Visitor.first.authentication_token))
      end
    end
    context 'visitor from valid invite token' do
      it 'returns access token of invitee' do
        @inviter = create(:inviter)
        @invitee = create(:invitee)
        @invitation = create(:invitation,
                             invitee: @invitee,
                             inviter: @inviter,
                             campaign_id: campaign.id)
        expect do
          get "http://api.#{ENV['base_url']}/token.js",
              {},
              referer: "http://#{campaign.url}/i/#{@invitation.token}"
        end.to change(Visitor, :count).by(0)
        expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
          eq(@invitee.authentication_token))
      end
    end
    context 'visitor from invalid invite token' do
      it 'returns access token of new visitor' do
        expect do
          get "http://api.#{ENV['base_url']}/token.js",
              {},
              referer: "http://#{campaign.url}/i/fgdfkgn345kl43n5"
        end.to change(Visitor, :count).by(1)
        expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
          eq(Visitor.first.authentication_token))
      end
    end
    context 'visitor from valid share token' do
      it 'creates associated invitation and returns access token' do
        @sharer = create(:visitor)
        expect do
          get "http://api.#{ENV['base_url']}/token.js",
              {},
              referer: "http://#{campaign.url}/s/#{@sharer.share_token}"
        end.to change(Visitor::Invitation, :count).by(1)
      end
    end
    context 'visitor from invalid share token' do
      it 'returns access token of new visitor' do
        expect do
          get "http://api.#{ENV['base_url']}/token.js",
              {},
              referer: "http://#{campaign.url}/s/kjb435jk4kjb45kjb4"
        end.to change(Visitor::Invitation, :count).by(0)
        expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
          eq(Visitor.first.authentication_token))
      end
    end
  end
end
