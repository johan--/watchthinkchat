module Dashboard
  module Api
    class OptionsController < Dashboard::BaseResourceController
      respond_to :json

      protected

      def begin_of_association_chain
        current_user.campaigns.
                     find(params[:campaign_id]).
                     engagement_player.
                     survey.
                     questions.
                     find(params[:question_id])
      end
    end
  end
end
