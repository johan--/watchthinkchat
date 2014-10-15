class SplitVisitorsIntoOwnModel < ActiveRecord::Migration
  def change
    rename_table :user_interactions, :visitor_interactions
    create_table(:visitors) do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :authentication_token
    end

    add_index :visitors, :email,                unique: true
    add_index :visitors, :authentication_token, unique: true
  end
end
