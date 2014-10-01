class CreateCampaignGuidedPairs < ActiveRecord::Migration
  def change
    create_table :campaign_guided_pairs do |t|
      t.boolean :enabled, default: true
      t.string :title
      t.text :description
      t.integer :campaign_id
      t.timestamps
    end
  end
end
