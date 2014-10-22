class RenameCampaignGuidedPairsToCampaignShares < ActiveRecord::Migration
  def change
    rename_table :campaign_guided_pairs, :campaign_shares
  end
end
