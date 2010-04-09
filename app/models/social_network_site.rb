def SocialNetworkSite(site_name)
    (site_name.to_s.camelize).constantize
end

class SocialNetworkSite
  class << self

    # Return a list of all the SocialNetworkSite (non-abstract) subclasses.
    # NOTE: Listing these manually, because determining them programatically would require loading all the subclasses first, which is kind of a chicken-and-egg problem.
    def all
      [Twitter]
    end

    # TODO: Can we replace these class methods with cattrs or something? Then have the parent class check for them and raise if they're not there.

    # Return the URL of an icon representing this site.
    def icon
      raise NotImplementedError
    end

    # Returns the kind authentication this site uses -- :oauth, :facebook, or other values to be determined later.
    def auth_type
      raise NotImplementedError
    end

    # Return a hash containing :username, :uid, and :full_name, according to the site.
    def get_user_details(account)
      raise NotImplementedError
    end

    # Have one user follow another on this site. (Or whatever is most analagous to following.)
    def follow(account, account_to_follow)
      raise NotImplementedError
    end

    def authenticate_to_network
      raise NotImplementedError
    end

  end
end