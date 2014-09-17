class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.references :resource, polymorphic: true
      t.integer :state, default: 0
      t.index :user_id, :resource_id
      t.index :user_id
      t.index :resource_id
    end
  end
end
