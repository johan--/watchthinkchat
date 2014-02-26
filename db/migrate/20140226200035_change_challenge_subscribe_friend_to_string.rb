class ChangeChallengeSubscribeFriendToString < ActiveRecord::Migration
  def change
    change_column :users, :challenge_subscribe_friend, :string
  end
end
