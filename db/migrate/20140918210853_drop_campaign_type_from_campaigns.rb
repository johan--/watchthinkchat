class DropCampaignTypeFromCampaigns < ActiveRecord::Migration
  def change
    remove_column :campaigns, :campaign_type, :string
  end
end
