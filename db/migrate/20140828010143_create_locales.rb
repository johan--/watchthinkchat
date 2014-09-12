class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :code
      t.string :name
      t.string :flag
      t.boolean :rtl, default: false

      t.timestamps
    end
  end
end
