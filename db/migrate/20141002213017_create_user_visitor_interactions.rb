class CreateUserVisitorInteractions < ActiveRecord::Migration
  def change
    create_table :user_interactions do |t|
      t.integer :resource_id
      t.index :resource_id
      t.string :resource_type
      t.integer :visitor_id
      t.index :visitor_id
      t.integer :campaign_id
      t.index :campaign_id
      t.integer :action
      t.text :data
      t.timestamps
    end
  end
end
