class AddLocaleIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :locale_id, :integer
    add_index :campaigns, :locale_id
  end
end
