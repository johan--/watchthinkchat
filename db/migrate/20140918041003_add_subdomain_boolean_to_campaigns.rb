class AddSubdomainBooleanToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :subdomain, :boolean, default: true
    rename_column :campaigns, :cname, :url
  end
end
