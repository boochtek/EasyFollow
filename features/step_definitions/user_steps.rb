Given /^the (.*) user exists$/ do |username|
  @user = Factory(:user, :username => username.trim_quotes)
end
Given /^the (.*) account does (?:not|NOT) exist$/ do |username|
  User.find_by_username(username.trim_quotes).should be_nil
end


Given /^the (.*) account exists$/ do |username|
  Factory(:user, :username => username.trim_quotes)
end
Given /^no (.*) account exists$/ do |username|
  User.find_by_username(username.trim_quotes).should be_nil
end


Given /^the (.*) account has a(?:|n) (.+) of "([^\"]*)"$/ do |username, prop, val|
  @user = User.find_by_username(username.trim_quotes)
  @user.send((prop+'=').to_sym, val)
  @user.send(prop.to_sym).should == val
  @user.save!
end

Given /^my account has the following details:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end


Given /^the CraigBuchek account has the following details:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end


