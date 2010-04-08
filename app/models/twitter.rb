class Twitter < OAuthSite

  def self.icon
    'http://a0.twimg.com/a/1270236195/images/twitter_logo_header.png'
  end

  def authenticate_to_network
  end

  def get_user_details(account)
    response = access_token(account).get('http://api.twitter.com/1/account/verify_credentials.json') # TODO: Can we drop the http://api.twitter.com/1 part?
    json = JSON.parse(response.body)
    return {:username => json['screen_name'], :uid => json['id'], :full_name => json['name']}
  end

  def follow(account, account_to_follow)
    account.access_token.post("http://api.twitter.com/1/friendships/create.json?screen_name=#{account_to_follow.username}")
  end


  def verify_oauth_result(account, params)
    access_token = super
    return nil if access_token.nil?
    response = access_token.get('http://api.twitter.com/1/account/verify_credentials.json') # TODO: Can we drop the http://api.twitter.com/1 part?
    return response.class == Net::HTTPOK
  end

end
