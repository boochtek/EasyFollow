# Config settings for OAuth.
# TODO: Should we make this a YAML file?

if defined?(OAuth)
  OAUTH_CREDENTIALS = {
    :twitter => {
      :key => 'MN7i4s3zrzbyLMMIFuw',
      :secret => '6KPug2dJxNehZvN4jBeMTl42fyX07Yl2B6dVAybIGMM',
      :site => 'http://twitter.com'
    },
    :linked_in => {
      :key => 'P6fffcQ5IFSAlMNfD0ZsFUy8c-c77VozYrYVvtZtTlmt-hLicy7NKF89ipfktGG_',
      :secret => 'bxm9kENLMYx2-y-JMMCxAC5IcMtErqx6JjVchz5vPJKCXF2B5m2mg1eeliQQt4yl',
      :site => 'https://api.linkedin.com',
      :request_token_path => '/uas/oauth/requestToken',
      :access_token_path => '/uas/oauth/accessToken',
      :authorize_path => '/uas/oauth/authorize'
    },
  }
end
