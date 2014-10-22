class AddServiceBooleansToCampaignShares < ActiveRecord::Migration
  def change
    add_column :campaign_shares, :facebook, :boolean, default: true
    add_column :campaign_shares, :twitter, :boolean, default: true
    add_column :campaign_shares, :link, :boolean, default: true
    add_column :campaign_shares, :email, :boolean, default: true
  end
end
