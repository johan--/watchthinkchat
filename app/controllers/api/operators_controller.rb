class Api::OperatorsController < ApplicationController
  before_filter :authenticate_user!, except: :show
  protect_from_forgery except: :auth

  def show
    operator = User.where(:operator_uid => params[:uid]).first

    if operator
      render json: operator.as_json(:as => :operator), status: 201
    else
      render json: { error: "Operator not found" }, status: 500
    end
  end

  def auth
    if user_signed_in?
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => current_user.id, # => required
        :user_info => { # => optional - for example
          :name => current_user.name,
          :email => current_user.email
        }
      })
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end

end
