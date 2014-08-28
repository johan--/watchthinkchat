class CreateAvailableLocales < ActiveRecord::Migration
  def change
    create_table :available_locales do |t|
      t.integer :campaign_id
      t.integer :locale_id

      t.timestamps
    end
  end
end
