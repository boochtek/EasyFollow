require 'nokogiri'

class LinkedIn < OAuthSite
  class << self

    def icon
      '/images/icons/linkedin.gif'
    end

    # Return a hash containing :username, :uid, and :full_name, according to the site.
    def get_user_details(account)
      # Get the user's profile information.
      response = access_token(account).get('http://api.linkedin.com/v1/people/~')
      xml = Nokogiri::XML(response.body)
      uid = xml.xpath('//person/id/text()').to_s
      first_name = xml.xpath('//person/first-name/text()').to_s
      last_name  = xml.xpath('//person/last-name/text()').to_s
      url = xml.xpath('//person/site-standard-profile-request/url/text()').to_s

      # Save the user's URL in the account token.
      account.token[:url] = url
      account.save!

      # Return the user details.
      return {:uid => uid, :full_name => "#{first_name} #{last_name}", :url => url}
    end

    # Have one user follow another on this site. (Or whatever is most analagous to following.)
    def follow(account, account_to_follow)
      # Have to get an authorization by locating the followee first.
      response = access_token(account).get("http://api.linkedin.com/v1/people/url=#{account_to_follow.token[:url]}")
      xml = Nokogiri::XML(response.body)
      auth = xml.xpath('//person/api-standard-profile-request/headers/http-header/value/text()').to_s.split(':')[1]
      xml = <<-"XML"
        <?xml version='1.0' encoding='UTF-8'?>
        <mailbox-item>
          <recipients>
            <recipient>
              <person path="/people/id=#{account_to_follow.uid}" />
            </recipient>
          </recipients>
          <subject>Invitation to Connect</subject>
          <body>Please join my professional network on LinkedIn. (sent via meezy.me)</body>
          <item-content>
            <invitation-request>
              <connect-type>friend</connect-type>
              <authorization>
                <name>NAME_SEARCH</name>
                <value>#{auth}</value>
              </authorization>
            </invitation-request>
          </item-content>
        </mailbox-item>
        XML
      access_token(account).post("http://api.linkedin.com/v1/people/~/mailbox", xml)
    end

    def authenticate_to_network
    end

    def verify_oauth_result(account, params)
      access_token = super
      return nil if access_token.nil?
      response = access_token.get('http://api.linkedin.com/v1/people/~')
      return response.class == Net::HTTPOK
    end

  end
end