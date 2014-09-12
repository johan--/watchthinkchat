class Dashboard::TranslationsController < Dashboard::BaseController
  def index
    load_translation_permissions
  end

  def edit
    load_translation_permission
  end

  protected

  def load_translation_permissions
    @translation_permissions ||= translation_permission_scope
  end

  def load_translation_permission
    @translation_permission ||= translation_permission_scope.find(params[:id])
    # authorize! :read, @translation_permission
    @campaign = @translation_permission.resource
    @translation_permission
  end

  def translation_permission_scope
    current_translator.permissions.where(resource_type: Campaign).translator
  end
end
