module Dashboard
  class BaseController < ApplicationController
    layout 'dashboard'
    before_filter :authenticate_by_facebook!
  end
end
