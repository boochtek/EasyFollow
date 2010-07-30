# NOTE: Connections are directional. User1 following User2 does not imply that User2 is following User1.

class Connection < ActiveRecord::Base

  attribute :network,  :string, :default => '' # Network that the user is following the other user on. Capitalized the same as the SocialNetworkSite subclass.

  belongs_to :follower, :class_name => 'User', :readonly => true
  belongs_to :followee, :class_name => 'User', :readonly => true

  validates_presence_of :follower
  validates_presence_of :followee

  # NOTE: This checks the raw network attribute. TODO: Make sure it's in the list of actual SocialNetworkSite subclasses.
  validates_format_of :network, :with => /\A[a-zA-Z_]*\Z/, :allow_nil => true, :message => 'must be a SocialNetworkSite names.'

  # Do the actual work to connect the 2 accounts.
  before_create :create_connection_on_social_network_site
  def create_connection_on_social_network_site
    site = SocialNetworkSite(network)
    follower_account = follower.accounts[network]
    followee_account = followee.accounts[network]
    if follower_account and followee_account
      site.follow(follower_account, followee_account)
    end
  rescue
    false # Don't create the Connection if we had some sort of problem.
  end
end
