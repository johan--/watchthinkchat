class AddNotifyInviterToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :notify_inviter, :boolean, default: false
  end
end
