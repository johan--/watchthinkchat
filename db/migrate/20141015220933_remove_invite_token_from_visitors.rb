class RemoveInviteTokenFromVisitors < ActiveRecord::Migration
  def change
    remove_column :visitors, :invite_token, :string
  end
end
