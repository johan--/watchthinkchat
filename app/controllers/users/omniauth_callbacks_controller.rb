class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    sign_in @user
    @user.extra_omniauth_info(request.env["omniauth.auth"]["info"])
    if session[:campaign]
      redirect_to "/operator/#{@user.operator_uid}?campaign=#{session[:campaign]}"
    else
      redirect_to session[:return_to] || '/'
      session[:return_to] = nil
    end
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end

  def failure
    session[:campaign] = nil
    redirect_to "/?t=invalid&m=#{failure_message}"
  end
end
