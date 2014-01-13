class SiteController < ApplicationController
  def index
    logger.info "Session: #{session.inspect}"
  end
end
