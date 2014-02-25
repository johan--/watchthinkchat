class AddMhCommentToChats < ActiveRecord::Migration
  def change
    add_column :chats, :mh_comment, :text
  end
end
