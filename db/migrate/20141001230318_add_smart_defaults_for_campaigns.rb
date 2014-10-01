class AddSmartDefaultsForCampaigns < ActiveRecord::Migration
  def change
    change_column :campaigns, :status, :integer, default: 0, null: false
  end
end
