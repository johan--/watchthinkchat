class Dashboard::Campaigns::PermissionsController < Dashboard::BaseController
  def destroy
    load_permission
    authorize! :manage, @permission.resource
    @permission.destroy
    redirect_to campaign_path(@permission.resource)
  end

  protected

  def load_permission
    @permission ||= permission_scope.find(params[:id])
    authorize! :manage, @permission.resource
    @permission
  end

  def permission_scope
    current_manager.campaigns
                   .find(params[:campaign_id])
                   .permissions
  end
end
