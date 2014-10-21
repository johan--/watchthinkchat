require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let(:campaign) { create(:campaign) }

  describe 'token' do
    describe 'visitor from unknown' do
      describe 'and visitor' do
        context 'is new' do
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
        context 'is old' do
          it 'returns original access token' do
            get "http://api.#{ENV['base_url']}/token.js",
                {},
                referer: "http://#{campaign.url}/"
            expect do
              get "http://api.#{ENV['base_url']}/token.js",
                  {},
                  referer: "http://#{campaign.url}/"
            end.to change(Visitor, :count).by(0)
            expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
              eq(Visitor.first.authentication_token))
          end
        end
      end
    end
    describe 'when invite token' do
      context 'is valid' do
        describe 'and visitor' do
          context 'is new' do
            it 'returns access token of invitee' do
              @inviter = create(:inviter)
              @invitee = create(:invitee)
              @invitation = create(:invitation,
                                   invitee: @invitee,
                                   inviter: @inviter,
                                   campaign: campaign)
              expect do
                get "http://api.#{ENV['base_url']}/token.js",
                    {},
                    referer: "http://#{campaign.url}/i/#{@invitation.token}"
              end.to change(Visitor, :count).by(0)
              expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
                eq(@invitee.authentication_token))
            end
          end
          context 'is old' do
            it 'returns access token of old visitor' do
              get "http://api.#{ENV['base_url']}/token.js",
                  {},
                  referer: "http://#{campaign.url}/"
              @inviter = create(:inviter)
              @invitee = create(:invitee)
              @invitation = create(:invitation,
                                   invitee: @invitee,
                                   inviter: @inviter,
                                   campaign: campaign)
              expect do
                get "http://api.#{ENV['base_url']}/token.js",
                    {},
                    referer: "http://#{campaign.url}/i/#{@invitation.token}"
              end.to change(Visitor, :count).by(-1)
              expect { @invitee.reload }.to(
                raise_error ActiveRecord::RecordNotFound)
              expect(@invitation.reload.invitee).to(
                eq(Visitor::Invitee.first))
              expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
                eq(Visitor::Invitee.first.authentication_token))
            end
          end
        end
      end
      context 'is invalid' do
        describe 'and visitor' do
          context 'is new' do
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
          context 'is old' do
            it 'returns access token of old visitor' do
              get "http://api.#{ENV['base_url']}/token.js",
                  {},
                  referer: "http://#{campaign.url}/"
              expect do
                get "http://api.#{ENV['base_url']}/token.js",
                    {},
                    referer: "http://#{campaign.url}/i/fgdfkgn345kl43n5"
              end.to change(Visitor, :count).by(0)
              expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
                eq(Visitor.first.authentication_token))
            end
          end
        end
      end
    end
    describe 'when share token' do
      context 'is valid' do
        describe 'and visitor' do
          context 'is new' do
            it 'creates invitation and returns access token' do
              @sharer = create(:visitor)
              expect do
                get "http://api.#{ENV['base_url']}/token.js",
                    {},
                    referer: "http://#{campaign.url}/s/#{@sharer.share_token}"
              end.to change(Visitor::Invitation, :count).by(1)
            end
          end
          context 'is old' do
            it 'creates invitation and returns old visitor access token' do
              get "http://api.#{ENV['base_url']}/token.js",
                  {},
                  referer: "http://#{campaign.url}/"
              @current_visitor = Visitor.first
              @sharer = create(:visitor)
              expect do
                get "http://api.#{ENV['base_url']}/token.js",
                    {},
                    referer: "http://#{campaign.url}/s/#{@sharer.share_token}"
              end.to change(Visitor, :count).by(0)
              expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
                eq(@current_visitor.authentication_token))
            end
          end
        end
      end
      context 'is invalid' do
        describe 'and visitor' do
          context 'is new' do
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
          context 'is old' do
            it 'return access token of old visitor' do
              get "http://api.#{ENV['base_url']}/token.js",
                  {},
                  referer: "http://#{campaign.url}/"
              @current_visitor = Visitor.first
              expect do
                get "http://api.#{ENV['base_url']}/token.js",
                    {},
                    referer: "http://#{campaign.url}/s/kjb435jk4kjb45kjb4"
              end.to change(Visitor::Invitation, :count).by(0)
              expect(response.body[/\".*?\"/].gsub(/"/, '')).to(
                eq(@current_visitor.authentication_token))
            end
          end
        end
      end
    end
  end
end
