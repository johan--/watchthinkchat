module Api
  class V1Controller < ApplicationController
    before_action :cors_set_access_control_headers
    before_action :authenticate_user_from_token!
    before_action :load_campaign

    protected

    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] =
        '*'
      headers['Access-Control-Allow-Methods'] =
        'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] =
        '*'
      headers['Access-Control-Allow-Headers'] =
        'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

    def load_campaign
      return if request.referer.nil?
      url = URI(request.referer).host
      url.slice! ".#{ENV['base_url']}"
      url.slice! '.lvh.me' if Rails.env.test? # capybara-webkit bug
      @campaign = Campaign.opened.find_by(url: url).decorate
      Permission.find_or_create_by(resource: @campaign,
                                   user: current_visitor,
                                   state: Permission.states[:visitor])
    end

    def authenticate_user_from_token!
      user_token = params[:access_token].presence
      user = user_token && User.find_by(authentication_token: user_token.to_s)
      sign_in user, store: false if user
    end
  end
end
