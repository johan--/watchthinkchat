class AddPreemptiveChatToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :preemptive_chat, :boolean
  end
end
