module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # You need to implement the method below in your model
      @user = User::Omniauth.find(request.env['omniauth.auth'], request.host)
      sign_in @user
      set_flash_message(:notice,
                        :success,
                        kind: 'Facebook') if is_navigational_format?
      redirect_to root_path
    end
  end
end
