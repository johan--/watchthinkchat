class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :resource_id
      t.integer :user_id
      t.integer :state, default: 0, null: false
      t.string :resource_type
      t.timestamps
    end
  end
end
