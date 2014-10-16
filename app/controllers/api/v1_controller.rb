module Api
  class V1Controller < ApiController
    before_action :cors_set_access_control_headers
    before_action :authenticate_user_from_token!
    before_action :load_campaign

    protected

    def authenticate_user_from_token!
      user_token = params[:access_token].presence
      user = user_token && Visitor.find_by(authentication_token: user_token.to_s)
      sign_in user, store: false if user
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
