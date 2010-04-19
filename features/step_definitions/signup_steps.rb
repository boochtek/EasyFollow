

Given /^I have not signed up for an account$/ do
  Given %{no "#{@signup_username}" account exists}
end


When /^I fill out the signup form$/ do
  user = Factory.attributes_for(:user)
  fill_in 'Username', :with => user[:username]
  fill_in 'First Name', :with => user[:first_name]
  fill_in 'Last Name', :with => user[:last_name]
  fill_in 'Email Address', :with => user[:email]
  fill_in 'Password', :with => user[:password]
  check 'Agree to Terms'
end

When /^I fill out the signup form correctly$/ do
  When 'I fill out the signup form'
  check 'Agree to Terms'
  click_button 'Sign Up'
end

When /^I fill out the signup form incorrectly$/ do
  When 'I fill out the signup form'
  fill_in 'Email Address', :with => 'invalid_email_address'
  check 'Agree to Terms'
  click_button 'Sign Up'
end


When /^I enter a username that is in the restricted list$/ do
  restricted_username = 'logout'
  When 'I fill out the signup form'
  fill_in 'Username', :with => restricted_username
  click_button 'Sign Up'
end

When /^I enter a username that is already taken$/ do
  user = Factory(:user)
  When 'I fill out the signup form'
  fill_in 'Username', :with => user.username
  click_button 'Sign Up'
end

When /^I enter a username that contains a slash$/ do
  When 'I fill out the signup form'
  fill_in 'Username', :with => 'craig/buchek'
  click_button 'Sign Up'
end


Then /^I should(?:| still) be in "([^\"]*)" of the signup$/ do |step|
  Then %{I should see "#{step}"}
end

Then /^I should receive an email confirming that I've signed up$/ do
  user = @integration_session.controller.current_user
  Then %{"#{user.email}" should receive 1 email}
  When %{"#{user.email}" opens the email with subject "Welcome to #{SITE_NAME}"}
  Then %{they should see "#{user.full_name}" in the email body}
  Then %{they should see "#{user.username}" in the email body}
end
