class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string  :username,      :length => 50
      t.string  :first_name,    :length => 50
      t.string  :last_name,     :length => 50
      t.database_authenticatable :null => false
      t.lockable
      t.recoverable
      t.rememberable
      t.trackable
      t.timestamps
    end

    add_index :users, :username,             :unique => true
    add_index :users, :remember_token,       :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end
