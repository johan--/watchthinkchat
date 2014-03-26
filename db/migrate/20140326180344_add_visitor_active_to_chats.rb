class AddVisitorActiveToChats < ActiveRecord::Migration
  def change
    add_column :chats, :visitor_active, :boolean, :default => false
    Chat.reset_column_information
    Chat.all.each do |chat|
      chat.update_visitor_active!
    end
  end
end
