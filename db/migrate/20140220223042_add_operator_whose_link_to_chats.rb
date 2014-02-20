class AddOperatorWhoseLinkToChats < ActiveRecord::Migration
  def change
    add_column :chats, :operator_whose_link_id, :integer
  end
end
