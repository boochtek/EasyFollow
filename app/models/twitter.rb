class Twitter < OAuthSite
  class << self

    def icon
      '/images/social_networking_iconpack/twitter_32.png'
    end

    # Return a hash containing :username, :uid, and :full_name, according to the site.
    def get_user_details(account)
      response = access_token(account).get('http://api.twitter.com/1/account/verify_credentials.json') # TODO: Can we drop the http://api.twitter.com/1 part?
      json = JSON.parse(response.body)
      return {:username => json['screen_name'], :uid => json['id'], :full_name => json['name']}
    end

    # Have one user follow another on this site. (Or whatever is most analagous to following.)
    def follow(account, account_to_follow)
      account.access_token.post("http://api.twitter.com/1/friendships/create.json?screen_name=#{account_to_follow.username}")
    end

    def authenticate_to_network
    end

    def verify_oauth_result(account, params)
      access_token = super
      return nil if access_token.nil?
      response = access_token.get('http://api.twitter.com/1/account/verify_credentials.json') # TODO: Can we drop the http://api.twitter.com/1 part?
      return response.class == Net::HTTPOK
    end

  end
end