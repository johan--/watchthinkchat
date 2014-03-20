class Api::UrlFwdsController < ApplicationController
  def create
    url_fwd = UrlFwd.create! :full_url => params[:url]
    render json: { short_url: url_fwd.short_url }, status: 201
  end
end
