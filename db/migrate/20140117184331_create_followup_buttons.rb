class CreateFollowupButtons < ActiveRecord::Migration
  def change
    create_table :followup_buttons do |t|
      t.integer :chat_id
      t.string :btn_text
      t.string :btn_action
      t.string :btn_value
    end
  end
end
