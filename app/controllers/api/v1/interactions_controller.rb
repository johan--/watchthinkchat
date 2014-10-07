module Api
  module V1
    class InteractionsController < Api::V1Controller
      def create
        build_interaction
        save_interaction
        render json: @interaction.to_json,
               status: :created
      rescue ArgumentError, ActiveRecord::RecordInvalid => ex
        render json: { errors: ex.message }.to_json,
               status: :unprocessable_entity
      end

      def update
        load_interaction
        build_interaction
        save_interaction
        render json: @interaction.to_json,
               status: :ok
      rescue ArgumentError, ActiveRecord::RecordInvalid => ex
        render json: { errors: ex.message }.to_json,
               status: :unprocessable_entity
      end

      protected

      def load_interactions
        @interactions ||= interaction_scope
      end

      def load_interaction
        @interaction ||= interaction_scope.find(params[:id])
        authorize! :visitor, @interaction.campaign
        @interaction
      end

      def build_interaction
        @interaction ||= interaction_scope.build
        @interaction.attributes = interaction_params
      end

      def save_interaction
        authorize! :visitor, @interaction.campaign
        @interaction.save!
      end

      def interaction_scope
        current_visitor.interactions.where(campaign: @campaign)
      end

      def interaction_params
        interaction_params = params[:interaction]
        return {} unless interaction_params
        interaction_params.permit(:resource_id,
                                  :resource_type,
                                  :action,
                                  :data)
      end
    end
  end
end
