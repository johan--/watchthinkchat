class AddGrowthChallengeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :growth_challenge, :string, default: "operator"
  end
end
