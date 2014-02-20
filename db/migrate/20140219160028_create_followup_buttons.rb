class CreateFollowupButtons < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'followup_buttons'
      drop_table 'followup_buttons'
    end
    create_table :followup_buttons do |t|
      t.string :btn_text
      t.string :btn_action
      t.string :btn_value
      t.integer :campaign_id
      t.text :message_active_chat
      t.text :message_no_chat

      t.timestamps
    end
  end
end
