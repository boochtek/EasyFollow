Factory.define :twitter, :class => SocialNetworkAccount do |a|
  a.network_name  'Twitter'
  a.username      'TwitterAccount'
  a.full_name     'Twitter User'
end

Factory.define :twitter2, :class => SocialNetworkAccount do |a|
  a.network_name  'Twitter'
  a.username      'TwitterAccount2'
  a.full_name     'Twitter User Two'
end
