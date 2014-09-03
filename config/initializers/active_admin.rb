require 'active_admin/cancan_adapter'

ActiveAdmin.setup do |config|
  config.site_title = 'Godchat'
  config.authentication_method = :authenticate_admin_user!
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.batch_actions = true
  config.before_filter :check_blacklist_and_log
  config.before_filter :authenticate_active_admin_by_facebook!
end
