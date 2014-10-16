class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def token
    unless user_signed_in?
      visitor = Visitor.create
      sign_in visitor
    end
    @token = current_visitor.authentication_token
  end
end
