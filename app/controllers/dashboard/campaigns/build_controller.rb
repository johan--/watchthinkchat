module Dashboard
  module Campaigns
    class BuildController < Dashboard::BaseController
      include Wicked::Wizard

      steps :basic,
            :engagement_player,
            :survey,
            :share,
            :community,
            :opened

      helper_method :campaign_scope

      def show
        load_campaign
        unless @campaign.opened? || @campaign.status.to_sym == step ||
               future_step?(@campaign.status.to_sym)
          return redirect_to(
          campaign_build_path(campaign_id: @campaign, id: @campaign.status))
        end
        present_campaign
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

      def present_campaign
        @campaign = @campaign.decorate
      end

      def campaign_scope
        current_manager.campaigns
      end

      def save_campaign
        authorize! :update, @campaign
        @campaign.save
      end

      # rubocop:disable Metrics/MethodLength
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
            [:id,
             :enabled,
             :media_link,
             :media_start,
             :media_stop],
          share_attributes:
            [:id,
             :title,
             :description,
             :subject,
             :message,
             :enabled],
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
      # rubocop:enable Metrics/MethodLength
    end
  end
end
