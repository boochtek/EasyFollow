class OAuthSite < SocialNetworkSite
  class << self

    def auth_type
      :oauth
    end

    def oauth_authorize_url(account, callback_url)
      request_token = consumer.get_request_token(:oauth_callback => callback_url)
      account.token[:oauth_rtoken] = request_token.token
      account.token[:oauth_rsecret] = request_token.secret
      account.save!
      return request_token.authorize_url
    end

    def verify_oauth_result(account, params)
      request_token = OAuth::RequestToken.new(consumer, account.token[:oauth_rtoken], account.token[:oauth_rsecret])
      access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
      account.token[:oauth_rtoken] = account.token[:oauth_rsecret] = nil
      account.token[:oauth_atoken] = access_token.token
      account.token[:oauth_asecret] = access_token.secret
      account.save!
      return access_token
    end

  protected

    def access_token(account)
      @access_token ||= OAuth::AccessToken.new(consumer, account.token[:oauth_atoken], account.token[:oauth_asecret])
    end

    def request_token
      consumer.get_request_token # NOTE: request tokens are short-lived, so we generate a new one every time we need one.
    end

    def options
      @options ||= OAUTH_CREDENTIALS[self.name.underscore.to_sym]
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(options[:key], options[:secret], options)
    end

  end
end