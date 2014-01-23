class RemoveRolesFromUsersAndJustUseFlags < ActiveRecord::Migration
  def change
    remove_column :users, :roles_mask
    add_column :users, :operator, :boolean, :default => false
    add_column :users, :visitor, :boolean, :default => true
  end
end
