class AddChallengeBooleansToUser < ActiveRecord::Migration
  def change
    add_column :users, :challenge_subscribe_self, :boolean
    add_column :users, :challenge_subscribe_friend, :boolean
  end
end
