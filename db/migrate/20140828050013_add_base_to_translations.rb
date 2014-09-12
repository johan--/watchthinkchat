class AddBaseToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :base, :boolean, default: false
  end
end
