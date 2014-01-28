class AddStatusToChats < ActiveRecord::Migration
  def change
    add_column :chats, :status, :string
  end
end
