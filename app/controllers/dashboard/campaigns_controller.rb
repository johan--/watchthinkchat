module Dashboard
  class CampaignsController < Dashboard::BaseController
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
      @campaign.attributes = campaign_params
    end

    def save_campaign
      @campaign.save
    end

    def campaign_params
      campaign_params = params[:campaign]
      if campaign_params
        campaign_params.permit(:title, :conditional)
      else
        {}
      end
    end
  end
end
