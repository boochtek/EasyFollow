class PerNetworkConnections < ActiveRecord::Migration
  def self.up
    add_column :connections, :network, :string

    # Divide every connection into a separate connection for each network.
    Connection.all.each do |connection|
      (connection.networks || '').split(',').each do |network|
        Connection.create(:follower_id => connection.follower.id, :follower_id => connection.followee.id, :network => network)
      end
      Connection.destroy(connection.id)
    end

    remove_column :connections, :networks
  end

  def self.down
    add_column :connections, :networks, :string

    # Create a single connection for each follower/followee pair.
    User.all.each do |follower|
      User.all.each do |followee|
        connections = Connection.find(:first, :conditions => {:follower_id => follower.id, :followee_id => followee.id}) || []
        networks = connections.collect(&:network).join(',')
        Connection.create(:follower_id => follower.id, :followee_id => followee.id, :networks => networks) unless networks == ''
      end
    end
    # Delete connections that have no networks. (They will have a network, but not networks.)
    Connection.find(:all, :conditions => {:networks => ''}).each do |connection|
      Connection.destroy(connection.id)
    end

    remove_column :connections, :network    

  end
end
