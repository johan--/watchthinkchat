class RemoveLanguages < ActiveRecord::Migration
  def change
    drop_table :languages
    drop_table :user_languages
  end
end
