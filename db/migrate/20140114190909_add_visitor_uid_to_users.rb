class AddVisitorUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :visitor_uid, :string
  end
end
