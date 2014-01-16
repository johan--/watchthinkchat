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
        session[:campaign] ||= request.path
        puts "In TemplatesController, session: #{session.inspect}"
        puts "   #{session.keys}"
        puts "   #{session.values}"
        redirect_to user_omniauth_authorize_path(:facebook)
      end
    end
end
