class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def token
    unless user_signed_in?
      visitor = User::Visitor.create
      visitor.save
      sign_in visitor
    end
    current_user.roles << :visitor
    current_user.save
    @token = current_user.authentication_token
  end
end
