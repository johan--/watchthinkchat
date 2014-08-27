module Dashboard
  module Campaigns
    class BuildController < Dashboard::BaseController
      include Wicked::Wizard

      steps :basic, :engagement_player, :finish

      def show
        @campaign = Campaign.find(params[:campaign_id])
        case step
        when :finish
          @campaign.opened!
        end
        render_wizard
      end

      def update
        @campaign = Campaign.find(params[:campaign_id])
        @campaign.status = step
        @campaign.update_attributes(campaign_params)
        render_wizard @campaign
      end

      private

      def campaign_params
        params.require(:campaign)
          .permit(:name, engagement_player_attributes: [:id, :media_link])
      end
    end
  end
end
