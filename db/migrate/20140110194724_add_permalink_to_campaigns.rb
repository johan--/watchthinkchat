class AddPermalinkToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :permalink, :string
  end
end
