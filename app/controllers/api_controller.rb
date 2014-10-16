class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def token
    unless user_signed_in?
      visitor = load_visitor
      sign_in visitor
    end
    @token = current_visitor.authentication_token
  end

  private

  def load_visitor
    invite = URI(request.referer).path.match(%r{/i/(?<token>.*)/?})
    return Visitor.create if invite.nil?
    Visitor::Invitation.find_by(token: invite[:token]).invitee
  end
end
