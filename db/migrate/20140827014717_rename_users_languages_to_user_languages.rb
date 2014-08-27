class RenameUsersLanguagesToUserLanguages < ActiveRecord::Migration
  def change
    rename_table :users_languages, :user_languages
  end
end
