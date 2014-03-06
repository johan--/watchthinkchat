class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.string :ip
      t.string :host
      t.string :controller
      t.string :action
      t.string :path
      t.boolean :blocked

      t.timestamps
    end
  end
end
