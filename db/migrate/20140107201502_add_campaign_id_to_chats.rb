class AddCampaignIdToChats < ActiveRecord::Migration
  def change
    add_column :chats, "campaign_id", :integer
  end
end
