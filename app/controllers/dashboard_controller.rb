class DashboardController < Dashboard::BaseController
  def index
    authorize! :manage, Dashboard
  end
end
