class AddVisitorActiveToChats < ActiveRecord::Migration
  def change
    add_column :chats, :visitor_active, :boolean, default: false
  end
end
