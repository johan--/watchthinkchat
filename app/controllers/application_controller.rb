class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_visitor
    @visitor ||= Visitor.find(session[:visitor_id]) if session[:visitor_id]
    @visitor ||= Visitor.new
  end

  helper_method :current_visitor

  protected

    def authenticate_by_facebook!
      unless signed_in?
        session[:return_to] = request.path
        redirect_to user_omniauth_authorize_path(:facebook)
      end
    end

    def authenticate_admin_user!
      signed_in? && current_user.admin ? current_user : nil
    end

    def operator_app?
      request.domain == ENV['operator_app_url']
    end

    def ensure_operator_app
      unless operator_app?
        redirect_to '/'
      end
    end
end
