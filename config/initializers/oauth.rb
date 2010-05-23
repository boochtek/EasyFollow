# Config settings for OAuth.
# TODO: Should we make this a YAML file?

if defined?(OAuth) or defined?(OAuth2)
  OAUTH_CREDENTIALS = {
    :twitter => {
      :key => 'MN7i4s3zrzbyLMMIFuw',
      :secret => '6KPug2dJxNehZvN4jBeMTl42fyX07Yl2B6dVAybIGMM',
      :site => 'http://twitter.com',
    },
    :linked_in => {
      :key => 'P6fffcQ5IFSAlMNfD0ZsFUy8c-c77VozYrYVvtZtTlmt-hLicy7NKF89ipfktGG_',
      :secret => 'bxm9kENLMYx2-y-JMMCxAC5IcMtErqx6JjVchz5vPJKCXF2B5m2mg1eeliQQt4yl',
      :site => 'https://api.linkedin.com',
      :request_token_path => '/uas/oauth/requestToken',
      :access_token_path => '/uas/oauth/accessToken',
      :authorize_path => '/uas/oauth/authorize',
    },
    :face_book => {
      :id => '126514797359617',
      :key => '2b80538d2339cf402969696a2427f779',
      :secret => '9a8eb43959ff24b2834b4f2b14705be0',
      :site => 'https://graph.facebook.com',
    },
    :you_tube => {
      :key => 'meezy.boochtek.com',
      :secret => 'NWnFejsuH5iBjRFvn++60eXa',
      :site => "https://www.google.com",
      :request_token_path => "/accounts/OAuthGetRequestToken",
      :access_token_path => "/accounts/OAuthGetAccessToken",
      :authorize_path=> "/accounts/OAuthAuthorizeToken",
    },
  }
end

if Rails.env == 'staging'
  OAUTH_CREDENTIALS[:face_book] = {
    :id => '117755198264651',
    :key => 'd71d036e7b7e7b3fdf0c2abf58b0d036',
    :secret => '2c9be86bc13781f90f1d1c1792e78466',
    :site => 'https://graph.facebook.com',
  }
end
