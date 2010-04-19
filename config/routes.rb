ActionController::Routing::Routes.draw do |map|

  # Routes are matched in the order they are listed here, with the first match winning.
  # However, if you create the same named route, the LATTER will override the former when using that name (but not when matching an incoming request).

  # Home page
  map.root :controller => 'home'
  map.home '', :controller => 'home'

  # Contact/feedback page
  map.contact '/contact', :conditions => { :method => :get },
    :controller => 'feedback',
    :action => 'new'
  map.contact '/contact', :conditions => { :method => :post },
    :controller => 'feedback',
    :action => 'create'

  # This provides all the routes that Devise needs.
  map.devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup'}

  # I don't like the routes that Devise uses, so I override some of them, and create aliases for some of them.
  map.new_user_session '/login', :conditions => { :method => :get },
    :controller => 'sessions',
    :action => 'new'
  map.user_session '/login', :conditions => { :method => :post },
    :controller => 'sessions',
    :action => 'create'
  map.login '/login', :conditions => { :method => :get },
    :controller => 'sessions',
    :action => 'new'
  map.login '/login', :conditions => { :method => :post },
    :controller => 'sessions',
    :action => 'create'
  map.logout '/logout',
    :controller => 'sessions',
    :action => 'destroy'

  # Signup page
  map.signup '/signup', :conditions => { :method => :get },
    :controller => 'user',
    :action => 'new'
  map.signup '/signup', :conditions => { :method => :post },
    :controller => 'user',
    :action => 'create'

  # Networks page
  map.networks '/networks', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'index'
  map.network '/network/add/:network', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'new'
  map.network '/network/add/:network', :conditions => { :method => :post },
    :controller => 'network',
    :action => 'create'
  # The following route is for OAuth callbacks.
  map.network_oauth '/network/oauth/:network', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'create_oauth'

  # Profile pages -- we can use profile_url(:username => 'CraigBuchek')
  map.profile ':username', :conditions => { :method => :get },
    :controller => 'profile',
    :action => 'show'

end
