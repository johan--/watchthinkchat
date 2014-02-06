class AddAdminColumnsToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :admin1_id, :integer
    add_column :campaigns, :admin2_id, :integer
    add_column :campaigns, :admin3_id, :integer
  end
end
