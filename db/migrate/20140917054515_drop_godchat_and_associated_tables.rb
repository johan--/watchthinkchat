class DropGodchatAndAssociatedTables < ActiveRecord::Migration
  def change
    drop_table :campaign_god_chat_chats
    drop_table :campaign_god_chat_comments
    drop_table :campaign_god_chat_messages
    drop_table :emails
    drop_table :log_entries
    drop_table :url_fwds
    drop_table :blacklists
    drop_table :organizations
    drop_table :sessions
    drop_table :followup_buttons
    drop_table :user_operators

    remove_column :users, :answers
    remove_column :users, :visitor_uid
    remove_column :users, :admin
    remove_column :users, :visitor
    remove_column :users, :operator
    remove_column :users, :challenge_subscribe_self
    remove_column :users, :challenge_subscribe_friend
    remove_column :users, :challenge_friend_accepted
    remove_column :users, :assigned_operator1_id
    remove_column :users, :assigned_operator2_id
    remove_column :users, :bio
    remove_column :users, :campaign_id
    remove_column :users, :missionhub_id
    remove_column :users, :status
    remove_column :users, :location
    remove_column :users, :ip
    remove_column :users, :referrer
    remove_column :users, :channel
    remove_column :users, :locale
  end
end
