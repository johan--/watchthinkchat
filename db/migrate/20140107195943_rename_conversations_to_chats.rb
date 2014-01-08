class RenameConversationsToChats < ActiveRecord::Migration
  def change
    rename_table :conversations, 'chats'
    rename_column :messages, 'conversation_id', 'chat_id'
  end
end
