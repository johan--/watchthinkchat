module Dashboard
  class TranslationsController < Dashboard::BaseController
    def index
      load_translations
    end

    def edit
      load_translation
      load_base_translation
    end

    protected

    def load_translations
      @translations ||= translation_scope
    end

    def load_translation
      @translation ||= translation_scope.find(params[:id])
    end

    def load_base_translation
      @base_translation ||=
        @translation.campaign.translations.where('content != \'\'').base
    end

    def translation_scope
      current_translator.permissions.where(resource_type: Campaign).translator
    end
  end
end
