module Dashboard
  class CampaignsController < Dashboard::BaseResourceController
    def new
      @campaign = Campaign.create
      @campaign.permissions.create(user: current_user,
                                   state: Permission.states[:owner])
      redirect_to campaign_build_path(id: :basic, campaign_id: @campaign.id)
    end
  end
end
