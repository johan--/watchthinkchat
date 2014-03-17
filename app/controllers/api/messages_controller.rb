class Api::MessagesController < ApplicationController
  def create
    chat = Chat.where(:uid => params[:chat_uid]).first
    user = User.where("visitor_uid = ? OR operator_uid = ?", params[:user_uid], params[:user_uid]).first

    if chat && user
      message = chat.messages.create!(:user_id => user.id, :body => params[:message].to_s, :name => user.fullname, message_type: params[:message_type])
      Pusher["chat_#{chat.uid}"].trigger('event', {
        user_uid: params["user_uid"],
        message_type: params["message_type"],
        message: ERB::Util.html_escape(params["message"])
      })
      render json: { success: true }, status: 201
    elsif !chat
      render json: { error: "Chat not found" }, status: 500 
    elsif !user
      render json: { error: "User not found" }, status: 500 
    end
  end
end
