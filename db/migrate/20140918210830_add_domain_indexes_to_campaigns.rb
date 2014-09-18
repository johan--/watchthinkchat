class AddDomainIndexesToCampaigns < ActiveRecord::Migration
  def change
    add_index :campaigns, :url
  end
end
