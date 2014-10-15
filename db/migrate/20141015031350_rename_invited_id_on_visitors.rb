class RenameInvitedIdOnVisitors < ActiveRecord::Migration
  def change
    rename_column :visitors, :invited_id, :inviter_id
  end
end
