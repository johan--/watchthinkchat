module Api
  module V1
    class InteractionsController < Api::V1Controller
      def create
        load_interaction
        build_interaction
        save_interaction
        render json: @interaction.to_json, status: (@state)
      end

      protected

      def load_interaction
        @state = :created
        @interaction ||=
          interaction_scope.where(
            resource_id: interaction_params[:resource_id],
            resource_type: interaction_params[:resource_type],
            action: Visitor::Interaction.actions[interaction_params[:action]]
          ).first
        @state = :ok if @interaction
        @interaction
      end

      def build_interaction
        @interaction ||= interaction_scope.build
        @interaction.attributes = interaction_params
      end

      def save_interaction
        @interaction.save!
      end

      def interaction_scope
        current_visitor.interactions.where(campaign: @campaign)
      end

      def interaction_params
        InteractionParams.permit(params)
      end

      class InteractionParams
        def self.permit(params)
          params.require(:interaction).permit(:resource_id, :resource_type, :action, :data)
        end
      end
    end
  end
end
