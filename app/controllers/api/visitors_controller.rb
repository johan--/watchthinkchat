class Api::VisitorsController < Api::UsersController
  def create
    @user = User.create!(:first_name => params[:first_name])
    render json: @user
  end

  def update
    @user = User.where(:visitor_uid => params[:uid]).first
    chat = @user.visitor_chats.last
    unless chat
      render json: { error: "chat_not_found", message: "couldn't find a chat for that visitor" }, :status => 404
      return
    end
    params[:challenge_subscribe_self] ||= @user.challenge_subscribe_self # in case that param wasn't passed in
    @user.assigned_operator1_id = chat.operator_id
    @user.assigned_operator2_id = chat.operator_whose_link_id
    [ :fb_uid, :email, :challenge_subscribe_self, :challenge_subscribe_friend, :challenge_friend_accepted ].each do |param|
      if param == :email
        if (email = params[:visitor_email]) && (email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
          @user.email = params[:visitor_email] if params[:visitor_email]
        end
      else
        @user.send("#{param}=", params[param]) if params[param].present?
      end
    end
    @user.save!
    @user.sync_mh
    render json: @user
  end
end
