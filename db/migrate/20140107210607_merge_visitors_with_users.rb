class MergeVisitorsWithUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :fb_uid
      t.string :channel
      t.integer :missionhub_id
      t.integer :campaign_id
      t.string :locale
      t.text :answers
    end
    drop_table :visitors
  end
end
