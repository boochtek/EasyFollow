class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) {}
    add_column    :users, :login,         :string, :length => 50
    add_column    :users, :email_address, :string, :length => 100
    add_column    :users, :first_name,    :string, :length => 50
    add_column    :users, :last_name,     :string, :length => 50
    add_column    :users, :created_at,    :datetime
    add_column    :users, :updated_at,    :datetime
  end
  def self.down
    drop_table    :users
  end
end
