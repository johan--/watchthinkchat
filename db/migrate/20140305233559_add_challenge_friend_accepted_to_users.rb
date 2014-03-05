class AddChallengeFriendAcceptedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :challenge_friend_accepted, :string
  end
end
