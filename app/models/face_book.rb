class FaceBook < OAuth2Site
  class << self

    def auth_type
      :facebook
    end

    def icon
      '/images/social_networking_iconpack/facebook_32.png'
    end

    # Return a hash containing :username, :uid, and :full_name, according to the site.
    def get_user_details(account)
      response = access_token(account).get('/me')
      json = JSON.parse(response)
      return {:username => json['name'], :uid => json['id'], :full_name => json['first_name'] + ' ' + json['last_name'], :url => json['link']}
    end

    # Have one user follow another on this site. (Or whatever is most analagous to following.)
    def follow(account, account_to_follow)
      # TODO: access_token(account).post("/=#{account_to_follow.uid}") # NOTE: We'll need to get uid working first.
    end

    def authenticate_to_network
    end

    def verify_oauth_result(account, params)
      access_token = super
      return nil if access_token.nil?
      response = access_token.get('/me')
      return response.response.success? # response is a ResponseString, which is a string, plus response.response (a Faraday::Response), response.status, and response.headers.
    end

  end
end