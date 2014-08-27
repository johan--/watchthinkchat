module Dashboard
  module Api
    class QuestionsController < Dashboard::BaseController
      respond_to :json

      def index
        respond_with load_questions, include: :options_attributes
      end

      def show
        respond_with load_question, include: :options_attributes
      end

      def new
        respond_with build_question, include: :options_attributes
      end

      def create
        build_question
        save_question
      end

      def update
        load_question
        build_question
        save_question
      end

      def destroy
        load_question
        @question.destroy
        render json: @question
      end

      protected

      def load_questions
        @questions ||= question_scope
      end

      def load_question
        @question ||= question_scope.find(params[:id])
      end

      def build_question
        @question ||= question_scope.build
        @question.attributes = question_params
      end

      def save_question
        return unless @question.save!
        render json: @question.to_json(include: :options_attributes)
      end

      def question_scope
        current_user.campaigns
                     .find(params[:campaign_id])
                     .engagement_player
                     .survey
                     .questions
      end

      def question_params
        question_params = params[:question]
        if question_params
          if params[:options_attributes]
            question_params[:options_attributes] = params[:options_attributes]
          end
          question_params.permit(
            :title, :help_text, :position,
            options_attributes: [:id, :title, :conditional,
                                 :conditional_question_id,
                                 :_destroy])
        else
          {}
        end
      end
    end
  end
end
