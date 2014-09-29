module Dashboard
  module Api
    class OptionsController < Dashboard::BaseController
      respond_to :json

      def index
        respond_with load_options
      end

      def show
        respond_with load_option
      end

      def new
        respond_with build_option
      end

      def create
        build_option
        save_option
      end

      def update
        load_option
        build_option
        save_option
      end

      def destroy
        load_option
        authorize! :destroy, @option.campaign
        @option.destroy
        render json: @option
      end

      protected

      def load_options
        @options ||= option_scope
      end

      def load_option
        @option ||= option_scope.find(params[:id])
        authorize! :read, @option.campaign
        @option
      end

      def build_option
        @option ||= option_scope.build
        @option.attributes = option_params
      end

      def save_option
        authorize! :update, @option.campaign
        return unless @option.save
        render json: @option
      end

      def option_scope
        current_manager.campaigns
                       .find(params[:campaign_id])
                       .engagement_player
                       .survey
                       .questions
                       .find(params[:question_id])
                       .options
      end

      def option_params
        option_params = params[:option]
        if option_params
          option_params.permit(:title, :conditional)
        else
          {}
        end
      end
    end
  end
end
