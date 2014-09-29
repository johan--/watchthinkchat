class AddEnabledToCampaignCommunities < ActiveRecord::Migration
  def change
    add_column :campaign_communities, :enabled, :boolean, default: true
  end
end
