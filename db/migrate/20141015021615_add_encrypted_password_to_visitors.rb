class AddEncryptedPasswordToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :encrypted_password, :string
  end
end
