class Api::ChatsController < ApplicationController
  before_filter :ensure_operator, :only => :destroy

  def create
    campaign = Campaign.where(:uid => params[:campaign_uid]).first
    visitor = User.where(:visitor_uid => params[:visitor_uid]).first
    operator = User.where(:operator_uid => params[:operator_uid]).first

    if campaign && visitor && operator && operator.online?
      chat = Chat.create!(:campaign_id => campaign.id, :visitor_id => visitor.id)
      Pusher["operator_#{operator.operator_uid}"].trigger('newchat', {
        chat_uid: chat.uid,
        visitor_uid: visitor.visitor_uid,
        visitor_name: visitor.fullname,
        visitor_profile: ""
      })
      render json: { chat_uid: chat.uid, operator: operator.as_json(:as => :operator) }, status: 201
    elsif !operator
      render json: { error: "Operator not found" }, status: 500 
    elsif !operator.online?
      render json: { error: "Operator offline" }, status: 500 
    elsif !campaign
      render json: { error: "Campaign not found" }, status: 500 
    elsif !visitor
      render json: { error: "Visitor not found" }, status: 500 
    end
  end

  def destroy
    chat = Chat.where(:uid => params[:uid]).first
    if chat
      chat.close!
      render json: {}, status: 201
    else
      render json: { error: "Chat not found" }, status: 500 
    end
  end

  def operator_params
    params.permit(:campaign_uid, :visitor_uid)
  end

  def ensure_operator
    unless signed_in? && current_user.operator
      render json: { error: "must be operator" }, status: 500 
    end
  end
end
