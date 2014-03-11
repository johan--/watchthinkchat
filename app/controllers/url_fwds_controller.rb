class UrlFwdsController < ApplicationController
  def show
    u = UrlFwd.where(:uid => params[:uid]).first
    if u.full_url
      redirect_to u.full_url
    else
      redirect_to '/'
    end
  end
end
