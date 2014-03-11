class AddUrlFwdIdToUserOperators < ActiveRecord::Migration
  def change
    add_column :user_operators, :url_fwd_id, :integer
  end
end
