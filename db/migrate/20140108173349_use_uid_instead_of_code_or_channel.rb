class UseUidInsteadOfCodeOrChannel < ActiveRecord::Migration
  def change
    rename_column :campaigns, "code", "uid"
    #rename_index :campaigns, "index_campaigns_on_code", "index_campaigns_on_uid"

    rename_column :chats, "channel", "uid"
  end
end
