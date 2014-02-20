class AddTimestampsToFollowupButtons < ActiveRecord::Migration
  def change
    begin
      #add_column(:followup_buttons, :created_at, :datetime)
      #add_column(:followup_buttons, :updated_at, :datetime)
    rescue
    end
  end
end
