class AddInvitedIdToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :invited_id, :integer
    add_index :visitors, :invited_id
  end
end
