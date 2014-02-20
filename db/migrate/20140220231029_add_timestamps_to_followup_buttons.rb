class AddTimestampsToFollowupButtons < ActiveRecord::Migration
  def change
    add_column(:followup_buttons, :created_at, :datetime) unless FollowupButton.column_names.include?("created_at")
    add_column(:followup_buttons, :updated_at, :datetime) unless FollowupButton.column_names.include?("updated_at")
  end
end
