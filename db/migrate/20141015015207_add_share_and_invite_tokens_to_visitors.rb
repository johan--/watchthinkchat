class AddShareAndInviteTokensToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :invite_token, :string
    add_column :visitors, :share_token, :string
    add_index :visitors, :invite_token, unique: true
    add_index :visitors, :share_token, unique: true
  end
end
