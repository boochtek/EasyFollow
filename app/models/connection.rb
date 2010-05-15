# NOTE: Connections are directional. User1 following User2 does not imply that User2 is following User1.

class Connection < ActiveRecord::Base

  # NOTE: Probably should use a serialized field here, but that did not work too well for me. Instead, we use custom accessors.
  attribute :networks,  :string, :default => '' # comma-separated list of all networks shared between the 2 users

  belongs_to :follower, :class_name => 'User', :readonly => true
  belongs_to :followee, :class_name => 'User', :readonly => true

  validates_presence_of :follower
  validates_presence_of :followee

  # NOTE: This checks the raw networks attribute. Note also that there must be at least 1 network site.
  validates_format_of :networks, :with => /\A[a-zA-Z_,]*\Z/, :allow_nil => true, :message => 'must be a comma-separated list of SocialNetworkSite names.'

  # Don't allow setting networks from params.
  attr_protected :networks

  # Allow treating the networks field as an array.
  def networks
    (read_attribute(:networks) || '').split(',')
  end
  def networks=(array)
    array ||= []
    array = [array] if array.is_a?(String)
    write_attribute(:networks, array.join(','))
  end

  # Do the actual work to connect the 2 accounts.
  after_create :create_connections_on_social_network_sites
  def create_connections_on_social_network_sites
    follower.accounts.collect{|a| a.network_site}.each do |site|
      follower_account = follower.accounts[site.name]
      followee_account = followee.accounts[site.name]
      if followee_account
        site.follow(follower_account, followee_account)
        self.networks += site.name
      end
    end
  end
end
