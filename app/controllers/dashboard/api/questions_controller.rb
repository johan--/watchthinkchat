module Dashboard
  module Api
    class QuestionsController < Dashboard::BaseResourceController
      respond_to :json

      protected

      def begin_of_association_chain
        current_user.campaigns.
                     find(params[:campaign_id]).
                     engagement_player.
                     survey
      end

      def permitted_params
        params.permit(question: [:title, :help_text, :position])
      end
    end
  end
end
