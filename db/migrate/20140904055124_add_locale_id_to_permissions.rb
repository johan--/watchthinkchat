class AddLocaleIdToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :locale_id, :integer
  end
end
