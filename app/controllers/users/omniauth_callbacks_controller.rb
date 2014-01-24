class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    sign_in @user
    @user.update_attribute(:profile_pic, request.env["omniauth.auth"]["info"]["image"])
    if session[:campaign_id]
      redirect_to "/operator/#{@user.operator_uid}?campaign=#{session[:campaign_uid]}"
    else
      redirect_to session[:return_to] || '/'
      session[:return_to] = nil
    end
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end

  def failure
    set_flash_message :alert, :failure, :kind => OmniAuth::Utils.camelize(failed_strategy.name), :reason => failure_message
    if session[:campaign_id]
      session[:campaign_id] = nil
    else
      redirect_to "/?m=invalid"
    end
  end
end
