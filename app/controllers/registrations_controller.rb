class RegistrationsController < Devise::RegistrationsController
  after_action :dashboard_manager

  private

  def dashboard_manager
    return unless resource.persisted?
    current_user.roles << :manager
    current_user.save!
  end

  def sign_up_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :current_password)
  end
end
