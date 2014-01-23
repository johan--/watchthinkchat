class Api::MessagesController < ApplicationController
  def create
    chat = Chat.where(:uid => params[:chat_uid]).first
    user = User.where("visitor_uid = ? OR operator_uid = ?", params[:user_uid], params[:user_uid]).first

    if chat && user
      message = chat.messages.create!(:user_id => user.id, :body => params[:body], :name => user.fullname)
      Pusher["chat_#{chat.uid}"].trigger('event', {
        user_uid: params["user_uid"],
        message_type: params["message_type"],
        message: params["message"]
      })
      render json: { success: true }, status: 201
    elsif !chat
      render json: { error: "Chat not found" }, status: 500 
    elsif !user
      render json: { error: "User not found" }, status: 500 
    end
  end
end
