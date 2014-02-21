class Api::VisitorsController < Api::UsersController
  def create
    @user = User.create!(:first_name => params[:first_name])
    render json: @user
  end

  def update
    @user = User.where(:visitor_uid => params[:visitor_uid]).first
    @user.update_attributes(:fb_uid => params[:fb_uid], :email => params[:visitor_email], :challenge_subscribe_self => params[:challenge_subscribe_self], :challenge_subscribe_friend => params[:challenge_subscribe_friend])
    @user.sync_mh
    render json: @user
  end
end
