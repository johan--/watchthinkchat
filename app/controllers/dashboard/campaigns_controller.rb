module Dashboard
  class CampaignsController < Dashboard::BaseResourceController
    def new
      @campaign = Campaign.create
      redirect_to campaign_build_path(id: :basic, campaign_id: @campaign.id)
    end
  end
end
