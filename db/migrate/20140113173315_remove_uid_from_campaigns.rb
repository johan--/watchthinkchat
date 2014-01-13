class RemoveUidFromCampaigns < ActiveRecord::Migration
  def change
    remove_column :campaigns, :uid
  end
end
