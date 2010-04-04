def SocialNetworkSite(site_name)
    (site_name.to_s.camelize).constantize.new
end
class SocialNetworkSite
  def self.all
    [Twitter]
  end
  # TODO: Can we make these cattrs instead of methods? Then have the parent class check for them and raise if they're not there.
#  def self.name
#    raise NotImplementedError
#  end
  def self.icon
    raise NotImplementedError
  end
  def self.type # Returns :oauth or something else
    raise NotImplementedError
  end
end

class OAuthSite < SocialNetworkSite
  TWITTER_KEY = 'UiDEyexab1izhoAO4NDg'
  TWITTER_SECRET = 'LFYI3Yi3XrjaYv11uWotA1rbILb7rtGJA07bETc'
  TWITTER_OAUTH_BASE_URL = 'http://twitter.com'

  def type
    :oauth
  end
  def access_token
    @access_token ||= OAuth::AccessToken.new(consumer, session[:oauth_atoken], session[:oauth_asecret])
  end
  def request_token
    consumer.get_request_token(:oauth_callback => "http://easyfollow.local:3000/network/add/twitter") # NOTE: request tokens are short-lived, so we generate a new one every time we need one.
  end
  def consumer
    @consumer ||= OAuth::Consumer.new(TWITTER_KEY, TWITTER_SECRET, :site => TWITTER_OAUTH_BASE_URL)
  end

end


class Twitter < OAuthSite
  def self.icon
    'http://a0.twimg.com/a/1270236195/images/twitter_logo_header.png'
  end
  def authenticate_to_network
  end
  def username(account)
    '' #TODO
  end
  def follow(account, account_to_follow)
    account.access_token.post("http://api.twitter.com/1/friendships/create.json?screen_name=#{account_to_follow.username}")
  end
end


#class User
#  def follow(user_to_follow)
#    accounts.each{|account| account.follow(user_to_follow.accounts[account.network_name])}
#  end
#end

class SocialNetworkAccount
  attr_accessor :network_name
  attr_accessor :network_site
  attr_accessor :session ## TODO: This is temporary. We really need to be storing this stuff in AR.

  delegate :type, :to => :network_site
  delegate :consumer, :to => :network_site # TODO: Temp.

  def initialize(site_name, session)
    self.network_name = site_name.to_s
    self.network_site = SocialNetworkSite(site_name) # returns an object of class TwitterSite, FacebookSite, etc.
    self.session = session ## TODO: This is temporary. We really need to be storing this stuff in AR.
  end

  def username
    return nil if !authenticated_to_network_site?
    return session[:twitter_username]
  end

  def follow(account_to_follow)
    network_site.follow(self, account_to_follow) unless account_to_follow.nil?
  end

  def authenticated_to_network_site?
    case network_site.type
    when :oauth
#      session[:oauth_atoken] || session[:oauth_rtoken]
      session[:oauth_rtoken]
    else
      false # TODO
    end
  end

  def oauth_authorize_url(callback_url)
    @request_token = consumer.get_request_token(:oauth_callback => callback_url)
    session[:oauth_rtoken] = @request_token.token
    session[:oauth_rsecret] = @request_token.secret
    @request_token.authorize_url
  end

  def verify_oauth_result(params)
    @request_token = OAuth::RequestToken.new(consumer, session[:oauth_rtoken], session[:oauth_rsecret])
    session[:oauth_rtoken] = session[:oauth_rsecret] = nil
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:oauth_atoken] = @access_token.token
    session[:oauth_asecret] = @access_token.secret
    response = @access_token.get('http://api.twitter.com/1/account/verify_credentials.json') # TODO: Can we drop the http://api.twitter.com/1 part?
    return false if response.class != Net::HTTPOK
    json = JSON.parse(response.body)
    session[:twitter_username] = json['screen_name']
    session[:twitter_uid] = json['id']
    session[:twitter_name] = json['name']
    # TODO: Check to see if it worked, and return false if it didn't.
    return true
  end
end


class NetworkController < ApplicationController

  before_filter :must_be_logged_in
  helper_method :username_on_site_or_add_link

  # List the user's networks
  def index
    @networks = SocialNetworkSite.all
    render 'network/list'
  end

  # Enter info to connect to a network.
  def new
    @network = params[:network]
#    current_user.accounts[@network] ||= SocialNetworkAccount.new(@network)
#    @account = current_user.accounts[@network]
    @account = SocialNetworkAccount.new(@network, session)
    if !@account.authenticated_to_network_site? and @account.type == :oauth
      redirect_to @account.oauth_authorize_url("http://easyfollow.local:3000/network/add/twitter")
    elsif @account.type == :oauth
      # This should all be moved to 'create'.
      if @account.verify_oauth_result(params)
        flash[:notice] = "Successfully added the #{params[:network].humanize} network"
        redirect_to networks_path
      else
        flash[:notice] = "Something went wrong adding the #{params[:network].humanize} network"
        redirect_to networks_path
      end
    else
      # TODO: Non-OAuth authentication/authorization.
    end
  end

  # Connect to a network with the given network credentials.
  def create
    @network = params[:network]
    @account = current_user.accounts[@network]
    raise RuntimeError if @account.nil? # TODO: What should we do here?
    if @account.needs_oauth_completion
      @account.complete_oauth(params)
    else
      # TODO: This stuff not tested yet.
      @account = SocialNetworkAccount.new(params[:user].merge(:network => params[:network]))
      if @network.valid?
        @network.save!
        flash[:notice] = "Successfully added the #{@network.name} network"
        redirect_to networks_path
      else
        render 'network/add'
      end
    end
  end

protected

  def must_be_logged_in
    redirect_to home_path and return if !current_user
  end

  def username_on_site_or_add_link
#    @template.link_to('Add Network', network_path(:network => 'twitter'))
    session[:twitter_uid] ? session[:twitter_username] : @template.link_to('Add Network', network_path(:network => 'twitter'))
    # TODO: current_user.accounts.[network.name] ? current_user.accounts[network.name].username : link_to('Add Network', network_path(:network => network.name))
  end
end
