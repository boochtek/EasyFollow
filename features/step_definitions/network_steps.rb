SITES_TO_CHECK = %w[Twitter] # TODO: Add LinkedIn, Facebook, etc.
ACCOUNTS_TO_USE = {'Twitter' => 'CraigBuchek'}

Given /^(?:|I )have not joined any networks$/ do
  # TODO
end


When /^(?:|I )authorize this app to access my Twitter account$/ do
#  pending # express the regexp above with the code you wish you had
  visit network_oauth_url(:network => 'twitter')
end

When /^(?:|I )do not authorize this app to access my Twitter account$/ do
#  pending # express the regexp above with the code you wish you had
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

