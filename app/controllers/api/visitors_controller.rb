class Api::VisitorsController < Api::UsersController
  def create
    @user = User.create!(:first_name => params[:first_name])
    render json: @user
  end

  def update
    @user = User.where(:visitor_uid => params[:uid]).first
    chat = @user.visitor_chats.last
    params[:challenge_subscribe_self] ||= @user.challenge_subscribe_self # in case that param wasn't passed in
    @user.assigned_operator1_id = chat.operator_id
    @user.assigned_operator2_id = chat.operator_whose_link_id
    [ :fb_uid, :email, :challenge_subscribe_self, :challenge_subscribe_friend, :challenge_friend_accepted ].each do |param|
      if param == :email
        @user.email = params[:visitor_email] if params[:visitor_email]
      else
        @user.send("#{param}=", params[param]) if params[param].present?
      end
    end
    @user.save!
    @user.sync_mh
    render json: @user
  end
end
