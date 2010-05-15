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

end
