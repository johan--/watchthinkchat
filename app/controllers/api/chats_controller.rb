class Api::ChatsController < ApplicationController
=begin
  def create
    campaign = Campaign.find(params[:campaign_id])
    visitor = Visitor.find(params[:visitors][:id])
    operator = Operator.where(uid: operator_params[:fb_uid], provider: 'facebook')
                     .first_or_create(first_name: operator_params[:first_name], last_name: operator_params[:last_name])

    conversation = operator.conversations.where(visitor_id: visitor.id)
                                        .first_or_create!(topic: [visitor.name, campaign.name].join(' - '))

    render json: {link: channel_conversation_url(channel: conversation.channel)}
  end
=end

  def create
    campaign = Campaign.where(:permalink => params[:campaign_permalink]).first
    visitor = User.where(:visitor_uid => params[:visitor_uid]).first
    operator = User.where(:uid => params[:operator_uid]).first

    if campaign && visitor
      chat = Chat.create!(:campaign_id => campaign.id, :visitor_id => visitor.id)
      render json: { chat_uid: chat.uid, operator: operator }, status: 201
    elsif !campaign
      render json: { error: "Campaign not found" }, status: 500 
    elsif !visitor
      render json: { error: "Visitor not found" }, status: 500 
    end
  end

  def operator_params
    params.permit(:campaign_uid, :visitor_uid)
  end
end
