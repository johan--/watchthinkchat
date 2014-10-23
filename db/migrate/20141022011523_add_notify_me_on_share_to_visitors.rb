class AddNotifyMeOnShareToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :notify_me_on_share, :boolean, default: false
  end
end
