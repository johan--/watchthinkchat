class RenameMissionhubSecretToMissionhubToken < ActiveRecord::Migration
  def change
    rename_column :campaigns, :missionhub_secret, :missionhub_token
  end
end
