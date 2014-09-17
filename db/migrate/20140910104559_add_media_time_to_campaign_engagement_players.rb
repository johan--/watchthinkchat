class AddMediaTimeToCampaignEngagementPlayers < ActiveRecord::Migration
  def change
    add_column :campaign_engagement_players, :media_start, :integer
    add_column :campaign_engagement_players, :media_stop, :integer
  end
end
