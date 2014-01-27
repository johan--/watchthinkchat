class ChangeUserStatusToString < ActiveRecord::Migration
  def change
    change_column :users, :status, :string
  end
end
