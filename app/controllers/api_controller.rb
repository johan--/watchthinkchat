class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def token
    load_visitor
    sign_in @visitor unless visitor_signed_in?
    @token = current_visitor.authentication_token
  end

  def cors_preflight_check
    cors_set_access_control_headers
    render text: ''
  end

  private

  def load_visitor
    if request.referer
      @visitor ||= visitor_from_invitation
      @visitor ||= visitor_from_share
    end
    @visitor ||= current_visitor
    @visitor ||= Visitor.create
  end

  def visitor_from_share
    share = URI(request.referer).path.match(%r{/s/(?<token>.*)/?})
    return unless share
    load_campaign
    inviter = Visitor::Inviter.find_by(share_token: share[:token])
    return unless inviter
    Visitor::Invitation.create(
      invitee: current_visitor.try(:as, :invitee) || Visitor::Invitee.create,
      inviter: inviter,
      campaign: @campaign
    ).invitee.becomes Visitor
  end

  def visitor_from_invitation
    invite = URI(request.referer).path.match(%r{/i/(?<token>.*)/?})
    return unless invite
    unless visitor_signed_in?
      return Visitor::Invitation.find_by(token: invite[:token]).try(:invitee)
    end
    invite = Visitor::Invitation.find_by(token: invite[:token])
    return unless invite
    invite.invitee.destroy
    invite.update(invitee: current_visitor.as(:invitee))
    current_visitor
  end

  protected

  def load_campaign
    return unless request.referer
    url = URI(request.referer).host
    url.slice! ".#{ENV['base_url']}"
    url.slice! '.lvh.me' if Rails.env.test? # capybara-webkit bug
    @campaign = Campaign.opened.find_by(url: url).decorate
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] =
      'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] =
      'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'
  end
end
