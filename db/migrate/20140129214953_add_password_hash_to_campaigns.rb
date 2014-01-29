class AddPasswordHashToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :password_hash, :string
  end
end
