module Api
  module V1
    class VisitorsController < Api::V1Controller
      def show
        load_visitor
      end

      def update
        load_visitor
        build_visitor
        save_visitor
        render 'show', status: :ok
      rescue ArgumentError, ActiveRecord::RecordInvalid => ex
        render json: { errors: ex.message }.to_json,
               status: :unprocessable_entity
      end

      protected

      def load_visitor
        @visitor ||= visitor_scope
        @visitor
      end

      def build_visitor
        @visitor ||= visitor_scope.build
        @visitor.attributes = visitor_params
      end

      def save_visitor
        @visitor.save!
      end

      def visitor_scope
        current_visitor
      end

      def visitor_params
        visitor_params = params[:visitor]
        return {} unless visitor_params
        visitor_params.permit(:first_name,
                              :last_name,
                              :email)
      end
    end
  end
end
