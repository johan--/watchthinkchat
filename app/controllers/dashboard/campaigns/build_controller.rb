class Dashboard::Campaigns::BuildController < Dashboard::BaseController
  include Wicked::Wizard

  steps :basic,
        :engagement_player,
        :engagement_player_survey,
        :community,
        :opened

  helper_method :campaign_scope

  def show
    load_campaign
    unless @campaign.opened? ||
           @campaign.status.to_sym == step ||
           future_step?(@campaign.status.to_sym)
      redirect_to campaign_build_path(campaign_id: @campaign.id,
                                      id: @campaign.status)
      return
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
    @campaign.status = next_step if @campaign.valid?
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
    return {} unless campaign_params
    campaign_params.permit(
      :name,
      :locale_id,
      :url,
      :subdomain,
      locale_ids: [],
      engagement_player_attributes:
        [:id, :media_link],
      community_attributes:
        [:id,
         :title,
         :url,
         :other_campaign,
         :child_campaign_id,
         :description,
         :enabled]
    )
  end
end
