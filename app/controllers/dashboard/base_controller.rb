class Dashboard::BaseController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_by_facebook!

  protected

  def current_manager
    current_user.as :manager
  end

  def current_translator
    current_user.as :translator
  end
end
