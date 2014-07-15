class ManageController < ApplicationController
  before_filter :authenticate_by_facebook!

  def index
  end
end
