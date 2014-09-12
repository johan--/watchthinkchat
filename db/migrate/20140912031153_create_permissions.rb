class CreatePermissions < ActiveRecord::Migration
  def change
    return if ActiveRecord::Base.connection.table_exists? 'users'

    create_table 'permissions', force: true do |t|
      t.integer 'resource_id'
      t.integer 'user_id'
      t.integer 'state',
                default: 0,
                null: false
      t.string 'resource_type'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index :permissions, :resource_id
    add_index :permissions, :user_id
  end
end
