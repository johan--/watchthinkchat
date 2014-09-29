class CreateCampaignCommunities < ActiveRecord::Migration
  def change
    create_table :campaign_communities do |t|
      t.integer :campaign_id
      t.string :url
      t.text :description
      t.boolean :other_campaign
      t.integer :child_campaign_id

      t.timestamps
    end
  end
end
