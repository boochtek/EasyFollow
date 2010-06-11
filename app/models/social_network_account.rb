SocialNetworkSite # Make sure we get the SocialNetworkSite method.

class SocialNetworkAccount < ActiveRecord::Base

  attribute :network_name,  :string, :required => true, :min_length => 2, :max_length => 40
  attribute :username,      :string, :required => false
  attribute :uid,           :string, :required => false # NOTE: This is a string, because some sites (eg. LinkedIn) don't use decimal integers for their UIDs.
  attribute :full_name,     :string, :required => false
  attribute :token,         :text, :serialize => true # NOTE: We're just serializing the token info as a hash here, so we don't need to subclass this class for each SocialNetworkSite.

  belongs_to :user

  # Fix problem with serialized column not initializing. Setting a default value doesn't work. See http://jqr.github.com/2009/02/01/making-rails-serialize-even-better.html and http://obiefernandez.com/obie-advanced_active_record_presentation-rubyeast_2007.pdf for details.
  after_initialize :set_token_to_empty_hash
  after_create :set_token_to_empty_hash
  def set_token_to_empty_hash
    write_attribute(:token, {}) if read_attribute(:token).nil?
  end

  def network_site
    @network_site ||= SocialNetworkSite(network_name) # returns the Twitter, Facebook, etc. class.
  end

#  def username
#    return nil if !authenticated_to_network_site?
#    @username ||= read_attribute(:username) || network_site.get_user_details(self)[:username]
#  end


  def url
    return nil if !authenticated_to_network_site?
    @url ||= network_site.get_user_details(self)[:url]
  rescue
    return nil
  end

  delegate :auth_type, :to => :network_site
  delegate :oauth_authorize_url, :to => :network_site

  def verify_oauth_result(account, params)
    result = network_site.verify_oauth_result(account, params)
    user_details = network_site.get_user_details(self)
    if user_details
      self.username = user_details[:username]
      self.uid = user_details[:uid]
      self.full_name = user_details[:full_name]
      self.save!
    end
    return result
  end

  # NOTE: This takes a SocialNetworkAccount parameter.
  def follow(account_to_follow)
    network_site.follow(self, account_to_follow) unless account_to_follow.nil?
  end

  def authenticated_to_network_site?
    case network_site.auth_type
    when :oauth, :oauth2, :facebook
      token && token[:oauth_atoken]
    else
      false # TODO
    end
  end

end

