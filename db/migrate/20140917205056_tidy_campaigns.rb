class TidyCampaigns < ActiveRecord::Migration
  def change
    remove_column :campaigns, :youtube_url
    remove_column :campaigns, :video_id
    remove_column :campaigns, :permalink
    remove_column :campaigns, :uid
    remove_column :campaigns, :max_chats
    remove_column :campaigns, :chat_start
    remove_column :campaigns, :owner
    remove_column :campaigns, :user_id
    remove_column :campaigns, :description
    remove_column :campaigns, :language
    remove_column :campaigns, :password_hash
    remove_column :campaigns, :admin1_id
    remove_column :campaigns, :admin2_id
    remove_column :campaigns, :admin3_id
    remove_column :campaigns, :preemptive_chat
    remove_column :campaigns, :growth_challenge
  end
end