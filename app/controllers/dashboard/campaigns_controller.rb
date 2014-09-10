class Dashboard::CampaignsController < Dashboard::BaseController
  def index
    load_campaigns
  end

  def new
    build_campaign
    save_campaign
    redirect_to campaign_build_path(id: :basic, campaign_id: @campaign.id)
  end

  def show
    load_campaign
  end

  def destroy
    load_campaign
    authorize! :destroy, @campaign
    @campaign.destroy
    redirect_to campaigns_path
  end

  protected

  def load_campaigns
    @campaigns ||= campaign_scope
  end

  def load_campaign
    @campaign ||= campaign_scope.find(params[:id])
    authorize! :read, @campaign
    @campaign
  end

  def campaign_scope
    current_manager.campaigns.owner
  end

  def build_campaign
    @campaign ||= campaign_scope.build
    current_manager.campaigns << @campaign
    current_manager.permissions.find_by(resource: @campaign).owner!
  end

  def save_campaign
    @campaign.save
  end
end
