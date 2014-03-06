class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.string :ip
      t.integer :blocked_count, :default => 0

      t.timestamps
    end
  end
end
