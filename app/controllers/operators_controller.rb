class OperatorsController < ApplicationController
  before_filter :ensure_operator_app
  before_filter :authenticate_by_facebook!

  def show
    @campaign = Campaign.where('uid = ? OR permalink = ?',
                               params[:campaign],
                               params[:campaign])
    if !@campaign
      redirect_to '/?t=invalid&m=could not find campaign'
      return
    end
    redirect_to '/?t=invalid&m=current user is not an operator '\
                'or is missing operator_uid' unless current_user.operator_uid.
                                                                 present?
  end
end
