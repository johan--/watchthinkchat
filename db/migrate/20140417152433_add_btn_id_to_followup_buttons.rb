class AddBtnIdToFollowupButtons < ActiveRecord::Migration
  def change
    add_column :followup_buttons, :btn_id, :integer
  end
end
