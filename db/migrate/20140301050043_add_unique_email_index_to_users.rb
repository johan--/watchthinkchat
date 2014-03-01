class AddUniqueEmailIndexToUsers < ActiveRecord::Migration
  def change
    remove_index :users, :email
    User.connection.execute("CREATE UNIQUE INDEX users_notnull_email ON users (email) WHERE email != '';")
  end
end
