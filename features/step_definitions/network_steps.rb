SITES_TO_CHECK = %w[Twitter] # TODO: Add LinkedIn, Facebook, etc.
ACCOUNTS_TO_USE = {'Twitter' => 'CraigBuchek'} # NOTE: FakeWeb pages will manually have to match these.



Given /^(?:|I )have not joined any networks$/ do
  SocialNetworkAccount.all.should == []
end


When 'I follow "Add Network" within "#Twitter"' do
  stub_post('http://twitter.com/oauth/request_token', 'twitter_request_token')
  # NOTE: We should get redirected to http://twitter.com/oauth/authorize?oauth_token=fake_request_token when clicking on 'Add Network', but Webrat does not redirect to external URLs.
  # NOTE: We'll use a different When clause to simulate the redirection back to our site.
  click_link_within('#Twitter', 'Add Network')
  # Check that we would normally be redirecting to the Twitter authorization page.
  @integration_session.response.headers['Location'].should == 'http://twitter.com/oauth/authorize?oauth_token=fake_request_token'
end


When /^(?:|I )authorize this app to access my Twitter account$/ do
  stub_get('http://api.twitter.com/1/account/verify_credentials.json', 'twitter_verify_credentials.json')
  stub_post('http://twitter.com/oauth/access_token', 'twitter_access_token')
  visit network_oauth_url(:network => 'Twitter')
end

When /^(?:|I )do not authorize this app to access my Twitter account$/ do
  stub_get('http://api.twitter.com/1/account/verify_credentials.json', 'twitter_verify_credentials.json')
  visit network_oauth_url(:network => 'Twitter') + '?denied=true'
end


Then /^(?:|I )should see "([^\"]*)" for each networking site$/ do |text|
  SITES_TO_CHECK.each do |site|
    Then "I should see \"#{text}\" within \"##{site}\""
  end
end


Then /^(?:|I )should see a list of networking sites$/ do
  SITES_TO_CHECK.each do |site|
    Then "I should see \"#{site}\""
  end
end


Then /^(?:|I )should see my ([^\"]*) account name within "([^\"]*)"$/ do |site, scope|
  Then "I should see \"#{ACCOUNTS_TO_USE[site]}\" within \"#{scope}\""
end

