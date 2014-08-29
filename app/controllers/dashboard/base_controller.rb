class Dashboard::BaseController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_by_facebook!
end
