class Api::VisitorsController < Api::UsersController
  def create
    @user = User.create!(:first_name => params[:first_name])
    render json: @user
  end
end
