class RemoveUserIdFromChats < ActiveRecord::Migration
  def change
    remove_column(:chats, :user_id) if Chat.column_names.include?("user_id")
  end
end
