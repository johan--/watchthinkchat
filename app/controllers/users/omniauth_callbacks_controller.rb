class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    sign_in @user
    @user.update_attribute(:profile_pic, request.env["omniauth.auth"]["info"]["image"])
    @user[:type] = "Operator"
    @user.save!
    return_to = session[:return_to]
    session[:return_to] = nil
    redirect_to return_to || '/'
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end

  def failure
    set_flash_message :alert, :failure, :kind => OmniAuth::Utils.camelize(failed_strategy.name), :reason => failure_message
    redirect_to "/"
  end
end
