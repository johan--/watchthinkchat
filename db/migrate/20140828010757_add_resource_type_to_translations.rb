class AddResourceTypeToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :resource_type, :string
  end
end
