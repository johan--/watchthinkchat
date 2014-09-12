class RemoveUserIdFromChats < ActiveRecord::Migration
  def change
    remove_column(:chats, :user_id) if column_exists?(:chats, :user_id)
  end
end
