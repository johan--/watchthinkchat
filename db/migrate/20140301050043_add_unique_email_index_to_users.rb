class AddUniqueEmailIndexToUsers < ActiveRecord::Migration
  def change
    begin
      remove_index :users, :email
    rescue
    end
    begin
      # this will be getting removed in a future migration anyways
      #User.connection.execute("CREATE UNIQUE INDEX users_notnull_email ON users (email) WHERE email != '';")
    rescue
    end
  end
end
