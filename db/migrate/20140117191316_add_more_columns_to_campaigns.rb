class AddMoreColumnsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :max_chats, :integer
    add_column :campaigns, :chat_start, :string
    add_column :campaigns, :owner, :string
    add_column :campaigns, :user_id, :integer
    add_column :campaigns, :description, :string
    add_column :campaigns, :language, :string
    add_column :campaigns, :status, :string
  end
end
