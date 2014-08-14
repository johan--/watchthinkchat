class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_blacklist_and_log

  def current_visitor
    @visitor ||= Visitor.find(session[:visitor_id]) if session[:visitor_id]
    @visitor ||= Visitor.new
  end

  helper_method :current_visitor

  protected

  def authenticate_by_facebook!
    return if signed_in?
    session[:return_to] = request.path
    session[:campaign] = nil
    redirect_to user_omniauth_authorize_path(:facebook)
  end

  def authenticate_active_admin_by_facebook!
    authenticate_by_facebook! if request.path =~ /^\/admin/
  end

  def ensure_operator_json
    return unless operator?
    render json: { error: 'Operator access required for this operator' },
           status: 401
  end

  def operator?
    signed_in? && current_user.operator
  end

  def authenticate_admin_user!
    signed_in? && current_user.fb_uid.present?
  end

  def operator_app?
    request.domain == ENV['operator_app_url']
  end

  def ensure_operator_app
    return unless operator_app?
    redirect_to '/'
  end

  def check_blacklist_and_log
    return if controller_name == 'pusher'
    blacklist = Blacklist.where(ip: request.ip).first
    if blacklist
      blocked = true
      blacklist.update_attribute(:blocked_count, blacklist.blocked_count + 1)
    else
      blocked = false
    end

    LogEntry.create! ip: request.ip,
                     host: request.host,
                     controller: controller_name,
                     action: action_name,
                     path: request.path,
                     blocked: blocked

    render inline: '' if blocked
  end

  # def access_denied(exception)
  #   redirect_to "/", alert: exception.message
  # end
end
