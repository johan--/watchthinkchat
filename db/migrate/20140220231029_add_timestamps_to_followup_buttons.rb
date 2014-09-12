class AddTimestampsToFollowupButtons < ActiveRecord::Migration
  def change
    add_column(:followup_buttons, :created_at, :datetime) unless column_exists?(:followup_buttons, :created_at)
    add_column(:followup_buttons, :updated_at, :datetime) unless column_exists?(:followup_buttons, :updated_at)
  end
end
