def SocialNetworkSite(site_name)
    (site_name.to_s.camelize).constantize.new
end

class SocialNetworkSite
  def self.all
    [Twitter]
  end
  # TODO: Can we make these cattrs instead of methods? Then have the parent class check for them and raise if they're not there.
  def self.icon
    raise NotImplementedError
  end
  def self.type # Returns :oauth or something else
    raise NotImplementedError
  end
  def get_user_details(account)
    raise NotImplementedError
  end
end
