class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def token
    unless user_signed_in?
      load_visitor
      sign_in @visitor
    end
    @token = current_visitor.authentication_token
  end

  private

  def load_visitor
    unless request.referer.nil?
      @visitor ||= visitor_from_invitation
      @visitor ||= visitor_from_share
    end
    @visitor ||= Visitor.create
  end

  def visitor_from_share
    share = URI(request.referer).path.match(%r{/s/(?<token>.*)/?})
    return if share.nil?
    load_campaign
    inviter = Visitor::Inviter.find_by(share_token: share[:token])
    return if inviter.nil?
    Visitor::Invitation.create(invitee: Visitor::Invitee.create,
                               inviter: inviter,
                               campaign: @campaign).invitee
  end

  def visitor_from_invitation
    invite = URI(request.referer).path.match(%r{/i/(?<token>.*)/?})
    return if invite.nil?
    Visitor::Invitation.find_by(token: invite[:token]).try(:invitee)
  end

  protected

  def load_campaign
    return if request.referer.nil?
    url = URI(request.referer).host
    url.slice! ".#{ENV['base_url']}"
    url.slice! '.lvh.me' if Rails.env.test? # capybara-webkit bug
    @campaign = Campaign.opened.find_by(url: url).decorate
  end
end
