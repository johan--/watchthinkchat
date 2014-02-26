class AddAssignedOperatorsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :assigned_operator1_id, :integer
    add_column :users, :assigned_operator2_id, :integer
  end
end
