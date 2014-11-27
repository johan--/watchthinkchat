class AddSubjectAndMessageToCampaignShares < ActiveRecord::Migration
  def change
    add_column :campaign_shares, :subject, :string
    add_column :campaign_shares, :message, :text
  end
end
