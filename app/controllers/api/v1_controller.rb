module Api
  class V1Controller < ApiController
    before_action :cors_set_access_control_headers
    before_action :authenticate
    before_action :load_campaign

    protected

    def authenticate
      authenticate_header_token || authenticate_param_token || render_unauthorized
    end

    def authenticate_header_token
      authenticate_with_http_token do |token, _options|
        sign_in Visitor.find_by(authentication_token: token)
      end
    end

    def authenticate_param_token
      token = params[:access_token].presence
      sign_in(token && Visitor.find_by(authentication_token: token.to_s), store: false)
    rescue
      false
    end

    def render_unauthorized
      headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: 'Bad credentials', status: 401
    end

    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] =
        'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] =
        'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end
  end
end
