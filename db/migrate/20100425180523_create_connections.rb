class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table(:connections) {}
    add_column    :connections, :networks, :string
    add_column    :connections, :follower_id, :integer
    add_column    :connections, :followee_id, :integer
  end
  def self.down
    drop_table    :connections
  end
end
