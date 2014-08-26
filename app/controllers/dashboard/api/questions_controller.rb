module Dashboard
  module Api
    class QuestionsController < Dashboard::BaseController
      respond_to :json

      def index
        respond_with load_questions
      end

      def show
        respond_with load_question
      end

      def new
        respond_with build_question
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
        return unless @question.save
        render json: @question
      end

      def question_scope
        current_user.campaigns.
                     find(params[:campaign_id]).
                     engagement_player.
                     survey.
                     questions
      end

      def question_params
        question_params = params[:question]
        if question_params
          question_params.permit(:title, :help_text, :position)
        else
          {}
        end
      end
    end
  end
end
