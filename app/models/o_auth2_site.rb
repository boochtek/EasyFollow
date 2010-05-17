require 'oauth2'

class OAuth2Site < SocialNetworkSite
  class << self

    def auth_type
      :oauth2
    end

    def oauth_authorize_url(account, callback_url)
      client.web_server.authorize_url(:redirect_uri => callback_url)
    end

    def verify_oauth_result(account, params)
      access_token = client.web_server.get_access_token(params[:code], :redirect_uri => params[:callback_url])
      account.token[:oauth_atoken] = access_token.token
      account.save!
      return access_token
    end

  protected

    def access_token(account)
      OAuth2::AccessToken.new(client, account.token[:oauth_atoken])
    end

    def options
      @options ||= OAUTH_CREDENTIALS[self.name.underscore.to_sym]
    end

    def client
      @client ||= OAuth2::Client.new(options[:id], options[:secret], :site => options[:site])
    end

  end
end