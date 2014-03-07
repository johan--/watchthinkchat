class Api::ChatsController < ApplicationController
  before_filter :ensure_operator, :only => [ :destroy, :collect_stats ]

  def show
    chat = Chat.where(:uid => params[:uid], :operator_id => current_user.id).first
    if chat
      render json: {
        campaign_uid: chat.campaign.uid,
        visitor: { uid: chat.visitor.visitor_uid, name: chat.visitor.name },
        operator: { uid: chat.operator.operator_uid, name: chat.operator.name },
        transcript: chat.messages
      }
    else
      render json: { error: "chat_not_found", message: "Sorry, that chat can not be found" }, status: 403
    end
  end

  def create
    campaign = Campaign.where(:uid => params[:campaign_uid]).first
    visitor = User.where(:visitor_uid => params[:visitor_uid]).first
    operator = User.where(:operator_uid => params[:operator_uid]).first
    requested_operator = User.where(:operator_uid => params[:operator_uid]).first
    if (campaign.max_chats && operator && operator.count_operator_open_chats_for(campaign) >= campaign.max_chats) || 
      !operator || 
      !operator.online?

      operator = campaign.get_available_operator
    end
    #puts operator.inspect

    if campaign && campaign.opened? && visitor && operator && operator.online?
      chat = Chat.create!(:campaign_id => campaign.id, :visitor_id => visitor.id, :operator_id => operator.id, :operator_whose_link_id => requested_operator.try(:id))
      Pusher["operator_#{operator.operator_uid}"].trigger('newchat', {
        chat_uid: chat.uid,
        visitor_uid: visitor.visitor_uid,
        visitor_name: visitor.fullname,
        visitor_profile: "",
        requested_operator: requested_operator.try(:operator_uid).to_s
      })
      render json: { chat_uid: chat.uid, operator: operator.as_json(:as => :operator) }, status: 201
    elsif campaign && !campaign.opened?
      render json: { error: "campaign_closed", message: "Sorry, the campaign was closed" }, status: 403
    elsif !operator
      render json: { error: "no_operators_available", message: "Sorry, no operators are available" }, status: 500 
    elsif !campaign
      render json: { error: "campaign_not_found", message: "Campaign not found" }, status: 404 
    elsif !visitor
      render json: { error: "visitor_not_found", message: "Visitor not found" }, status: 404 
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

  def collect_stats
    chat = Chat.where(:uid => params[:uid]).first
    if chat
      chat.collect_stats(params.slice(:visitor_response, :visitor_name, :visitor_email, :calltoaction, :notes))
      render json: {}, status: 201
    else
      render json: { error: "Chat not found" }, status: 500 
    end
  end

  protected

  def operator_params
    params.permit(:campaign_uid, :visitor_uid)
  end

  def ensure_operator
    unless signed_in? && current_user.operator
      render json: { error: "must be operator" }, status: 500 
    end
  end
end
