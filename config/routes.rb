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
  map.signup2 '/signup2', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'index'
  map.signup3 '/signup3', :conditions => { :method => :get },
    :controller => 'user',
    :action => 'index'

  # Networks page
  map.network '/network/add/:network', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'new'
  map.network '/network/add/:network', :conditions => { :method => :post },
    :controller => 'network',
    :action => 'create'
  # The following routes are for OAuth and OAuth2 callbacks.
  map.network_oauth '/network/oauth/:network', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'create_oauth'
  map.network_oauth2 '/network/oauth2/:network', :conditions => { :method => :get },
    :controller => 'network',
    :action => 'create_oauth2'

  # Connections (following)
  map.create_connection '/connection/create', :conditions => { :method => :post },
    :controller => 'connection',
    :action => 'create'

  # Profile pages -- we can use profile_url(:username => 'CraigBuchek')
  map.profile ':username', :conditions => { :method => :get },
    :controller => 'profile',
    :action => 'show'
  map.edit_profile '/profile/edit', :conditions => { :method => :get },
    :controller => 'profile',
    :action => 'edit'
  map.edit_profile '/profile/edit', :conditions => { :method => [:post, :put] },
    :controller => 'profile',
    :action => 'update'
  # Make my_profile an alias for the home page (assuming the user is logged in)
  map.my_profile '', :controller => 'home'

  # Search page
  map.search '/search', :controller => 'search'

end
