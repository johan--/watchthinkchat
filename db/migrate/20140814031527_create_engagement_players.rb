class CreateEngagementPlayers < ActiveRecord::Migration
  def change
    create_table :engagement_players do |t|
      t.boolean :enabled
      t.string :media_link
      t.integer :campaign_id

      t.timestamps
    end
  end
end
