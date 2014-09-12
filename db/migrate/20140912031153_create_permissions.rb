class CreatePermissions < ActiveRecord::Migration
  def change
    return unless ActiveRecord::Base.connection.table_exists? 'users'

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

    add_index :resource_id
    add_index :user_id
  end
end
