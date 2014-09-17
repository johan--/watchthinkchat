class Dashboard::Campaigns::BuildController < Dashboard::BaseController
  include Wicked::Wizard

  steps :basic,
        :engagement_player,
        :engagement_player_survey,
        :finish

  def show
    load_campaign
    case step
    when :finish
      @campaign.opened!
    end
    render_wizard
  end

  def update
    load_campaign
    build_campaign
    save_campaign
    render_wizard @campaign
  end

  protected

  def load_campaign
    @campaign ||= campaign_scope.find(params[:campaign_id])
    authorize! :read, @campaign
  end

  def build_campaign
    @campaign.attributes = campaign_params
    @campaign.status = step
  end

  def campaign_scope
    current_manager.campaigns
  end

  def save_campaign
    authorize! :update, @campaign
    @campaign.save
  end

  def campaign_params
    campaign_params = params[:campaign]
    if campaign_params
      campaign_params.permit(:name,
                             :locale_id,
                             locale_ids: [],
                             engagement_player_attributes: [:id,
                                                            :media_link])
    else
      {}
    end
  end
end
