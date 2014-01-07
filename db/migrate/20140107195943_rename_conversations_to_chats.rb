class RenameConversationsToChats < ActiveRecord::Migration
  def change
    rename_table :conversations, 'chats'
    rename_column :messages, 'conversation_id', 'chat_id'
    #rename_index :messages, 'index_messages_on_conversation_id', 'index_messages_on_chat_id'
  end
end
