require 'nokogiri'

class YouTube < OAuthSite
  class << self

    def icon
      '/images/social_networking_iconpack/youtube_32.png'
    end

    # Return a hash containing :username, :uid, and :full_name, according to the site.
    def get_user_details(account)
      # Get the user's profile information.
      response = access_token(account).get('http://gdata.youtube.com/feeds/api/users/default')
      xml = Nokogiri::XML(response.body)
      username   = xml.xpath('//yt:username/text()',  {'yt' => 'http://gdata.youtube.com/schemas/2007'}).to_s
      first_name = xml.xpath('//yt:firstName/text()', {'yt' => 'http://gdata.youtube.com/schemas/2007'}).to_s
      last_name  = xml.xpath('//yt:lastName/text()',  {'yt' => 'http://gdata.youtube.com/schemas/2007'}).to_s

      # Return the user details.
      return {:username => username, :full_name => "#{first_name} #{last_name}"}
    end

    # Have one user follow another on this site. (Or whatever is most analagous to following.)
    def follow(account, account_to_follow)
      xml = <<-"XML"
        <?xml version="1.0" encoding="UTF-8"?>
        <entry xmlns="http://www.w3.org/2005/Atom"
            xmlns:yt="http://gdata.youtube.com/schemas/2007">
          <yt:username>#{account_to_follow.username}</yt:username>
        </entry>
        XML
      access_token(account).post("http://gdata.youtube.com/feeds/api/users/default/contacts", xml, {'Content-Type' => 'application/atom+xml', 'X-GData-Key' => "key=#{options[:developer_key]}"})
    end

    def authenticate_to_network
    end

    def verify_oauth_result(account, params)
      access_token = super
      return nil if access_token.nil?
      response = access_token.get('http://gdata.youtube.com/feeds/api/users/default')
      return response.class == Net::HTTPOK
    end

  end
end