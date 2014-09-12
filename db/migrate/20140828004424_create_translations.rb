class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.string :content
      t.integer :resource_id
      t.integer :campaign_id
      t.integer :locale_id
      t.string :field
      t.timestamps
    end

    add_index :translations, :resource_id
    add_index :translations, :campaign_id
    add_index :translations, :locale_id
    add_index :translations, :field

  end
end
