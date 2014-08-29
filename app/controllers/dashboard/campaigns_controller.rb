class Dashboard::CampaignsController < Dashboard::BaseController
  def index
    load_campaigns
  end

  def new
    build_campaign
    save_campaign
    redirect_to campaign_build_path(id: :basic, campaign_id: @campaign.id)
  end

  protected

  def load_campaigns
    @campaigns ||= campaign_scope
  end

  def campaign_scope
    current_user.campaigns
  end

  def build_campaign
    @campaign ||= campaign_scope.build
    campaign_scope << @campaign
  end

  def save_campaign
    @campaign.save
  end
end
