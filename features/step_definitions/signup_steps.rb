

Given /^I have not signed up for an account$/ do
  Given %{no "#{@signup_username}" account exists}
end


When /^I fill out the signup form$/ do
  user = Factory.attributes_for(:user)
  fill_in 'user[username]', :with => user[:username]
  fill_in 'user[first_name]', :with => user[:first_name]
  fill_in 'user[last_name]', :with => user[:last_name]
  fill_in 'user[email]', :with => user[:email]
  fill_in 'user[password]', :with => user[:password]
  check 'Agree to Terms'
end

When /^I fill out the signup form correctly$/ do
  When 'I fill out the signup form'
  check 'Agree to Terms'
  click_button 'Sign Up'
end

When /^I fill out the signup form incorrectly$/ do
  When 'I fill out the signup form'
  fill_in 'user[email]', :with => 'invalid_email_address'
  check 'Agree to Terms'
  click_button 'Sign Up'
end


When /^I enter a username that is in the restricted list$/ do
  restricted_username = 'logout'
  When 'I fill out the signup form'
  fill_in 'user[username]', :with => restricted_username
  click_button 'Sign Up'
end

When /^I enter a username that is already taken$/ do
  user = Factory(:user)
  When 'I fill out the signup form'
  fill_in 'user[username]', :with => user.username
  click_button 'Sign Up'
end

When /^I enter a username that contains a slash$/ do
  When 'I fill out the signup form'
  fill_in 'user[username]', :with => 'craig/buchek'
  click_button 'Sign Up'
end


Then /^I should(?:| still) be in "Step ([123])" of the signup$/ do |step|
  case step.to_i
  when 1
    Then %{I should see "Agree to Terms"}
  when 2
    Then %{I should see "Select at least one of the Meezy.me supported networks"}
  when 3
    Then %{I should see "Agree to Terms"}
  end
  Then %{I should see "#{step}"}
end

Then /^I should receive an email confirming that I've signed up$/ do
  user = @integration_session.controller.current_user
  Then %{"#{user.email}" should receive 1 email}
  When %{"#{user.email}" opens the email with subject "Welcome to #{SITE_NAME}"}
  Then %{they should see "#{user.full_name}" in the email body}
  Then %{they should see "#{user.username}" in the email body}
end
