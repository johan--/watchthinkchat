class MoveSurveyIntoItsOwnComponent < ActiveRecord::Migration
  def change
    rename_table :campaign_engagement_player_options,
                 :campaign_survey_question_options
    rename_table :campaign_engagement_player_questions,
                 :campaign_survey_questions
    rename_table :campaign_engagement_player_surveys,
                 :campaign_surveys
    add_column :campaign_surveys, :enabled, :boolean, default: true
    add_column :campaign_surveys, :campaign_id, :integer
    remove_column :campaign_surveys, :engagement_player_id, :integer
  end
end
