class AddVideoIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :video_id, :string
  end
end
