class AddUniqueEmailIndexToUsers < ActiveRecord::Migration
  def change
    begin
      remove_index :users, :email
    rescue
    end
    User.connection.execute("CREATE UNIQUE INDEX users_notnull_email ON users (email) WHERE email != '';")
  end
end
