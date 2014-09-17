class RefactorTableNamesToGraipStyle < ActiveRecord::Migration
  def change
    rename_table :engagement_players, :campaign_engagement_players
    rename_table :options, :campaign_engagement_player_options
    rename_table :questions, :campaign_engagement_player_questions
    rename_table :surveys, :campaign_engagement_player_surveys
    rename_table :chats, :campaign_god_chat_chats
    rename_table :comments, :campaign_god_chat_comments
    rename_table :messages, :campaign_god_chat_messages
  end
end
