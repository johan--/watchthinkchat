class AddTitleToCampaignCommunities < ActiveRecord::Migration
  def change
    add_column :campaign_communities, :title, :string
  end
end
