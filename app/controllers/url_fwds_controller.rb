class UrlFwdsController < ApplicationController
  def show
    u = UrlFwd.where(:uid => params[:uid]).first
    if u && u.full_url
      redirect_to u.full_url
    else
      redirect_to "/?t=invalid&m=share code not found"
    end
  end
end
