class AddMessagesCountToChats < ActiveRecord::Migration
  def change
    add_column :chats, :user_messages_count, :integer, :default => 0
  end
end
