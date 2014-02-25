class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :from_name
      t.text :message

      t.timestamps
    end
  end
end
