class RemoveEmailIndexOnUsers < ActiveRecord::Migration
  def change
    begin
      remove_index :emails, name: :users_notnull_email
    rescue
    end
  end
end
