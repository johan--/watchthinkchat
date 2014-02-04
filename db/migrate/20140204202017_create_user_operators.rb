class CreateUserOperators < ActiveRecord::Migration
  def change
    create_table :user_operators do |t|
      t.integer :user_id
      t.integer :campaign_id

      t.timestamps
    end
  end
end
