class SocialNetworkAccount
  attr_accessor :network_name # TODO: Store in AR
  attr_accessor :network_site
  attr_accessor :session ## TODO: This is temporary. We really need to be storing this stuff in AR.

  delegate :auth_type, :to => :network_site
  delegate :oauth_authorize_url, :to => :network_site
  delegate :verify_oauth_result, :to => :network_site
  delegate :consumer, :to => :network_site # TODO: Temp.

  def initialize(site_name, session)
    @network_name = site_name.to_s
    @network_site = SocialNetworkSite(site_name) # returns an object of class Twitter, Facebook, etc.
    @session = session ## TODO: This is temporary. We really need to be storing this stuff in AR.
  end

  def username
    return nil if !authenticated_to_network_site?
    @username ||= (session[:twitter_username] = network_site.get_user_details(self)[:username]) # TODO: Store in AR.
  end

  def follow(account_to_follow)
    network_site.follow(self, account_to_follow) unless account_to_follow.nil?
  end

  def authenticated_to_network_site?
    case network_site.type
    when :oauth
      session[:oauth_atoken]
    else
      false # TODO
    end
  end

end

