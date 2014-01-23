class ChangeUidToOperatorUid < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :operator_uid
  end
end
