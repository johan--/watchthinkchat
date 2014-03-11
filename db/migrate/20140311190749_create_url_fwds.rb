class CreateUrlFwds < ActiveRecord::Migration
  def change
    create_table :url_fwds do |t|
      t.string :short_url
      t.string :uid
      t.string :full_url

      t.timestamps
    end
  end
end
