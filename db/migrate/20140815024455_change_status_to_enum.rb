class ChangeStatusToEnum < ActiveRecord::Migration
  def change
    remove_column :campaigns, :status
    add_column :campaigns, :status, :integer, default: 0, null: false
  end
end
