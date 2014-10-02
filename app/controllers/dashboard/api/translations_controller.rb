module Dashboard
  module Api
    class TranslationsController < Dashboard::BaseController
      respond_to :json

      def show
        respond_with load_translation
      end

      def update
        load_translation
        build_translation
        save_translation
      end

      def destroy
        load_translation
        authorize! :translator, @translation.campaign
        @translation.destroy
        render json: @translation
      end

      protected

      def load_translation
        load_base_translation
        @translation ||=
          translation_scope.where(locale_id: params[:locale_id],
                                  resource: @base_translation.resource,
                                  field: @base_translation.field)
                           .first_or_create!
        authorize! :translator, @translation.campaign
        @translation
      end

      def build_translation
        @translation ||= translation_scope.build
        @translation.attributes = translation_params
      end

      def save_translation
        authorize! :translator, @translation.campaign
        return unless @translation.save!
        render json: @translation.to_json
      end

      def load_base_translation
        @base_translation ||= translation_scope.find(params[:id])
      end

      def translation_scope
        current_translator.campaigns
                          .find(params[:campaign_id])
                          .translation_groups
      end

      def translation_params
        translation_params = params[:translation]
        if translation_params
          translation_params.permit(:content)
        else
          {}
        end
      end
    end
  end
end
