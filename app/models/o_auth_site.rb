class OAuthSite < SocialNetworkSite

  def type
    :oauth
  end

  def access_token(account)
    @access_token ||= OAuth::AccessToken.new(consumer, account.session[:oauth_atoken], account.session[:oauth_asecret])
  end

  def request_token
    consumer.get_request_token # NOTE: request tokens are short-lived, so we generate a new one every time we need one.
  end

  def options
    @options ||= OAUTH_CREDENTIALS[self.class.name.downcase.to_sym]
  end

  def consumer
    @consumer ||= OAuth::Consumer.new(options[:key], options[:secret], options)
  end

  def oauth_authorize_url(account, callback_url)
    request_token = consumer.get_request_token(:oauth_callback => callback_url)
    account.session[:oauth_rtoken] = request_token.token
    account.session[:oauth_rsecret] = request_token.secret
    return request_token.authorize_url
  end

  def verify_oauth_result(account, params)
    request_token = OAuth::RequestToken.new(consumer, account.session[:oauth_rtoken], account.session[:oauth_rsecret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    account.session[:oauth_rtoken] = account.session[:oauth_rsecret] = nil
    account.session[:oauth_atoken] = access_token.token
    account.session[:oauth_asecret] = access_token.secret
    return access_token
  end

end
