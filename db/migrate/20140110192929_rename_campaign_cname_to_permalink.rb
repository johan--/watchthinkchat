class RenameCampaignCnameToPermalink < ActiveRecord::Migration
  def change
    rename_column :campaigns, :cname, :permalink
  end
end
