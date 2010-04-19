Given /^the (.*) user exists$/ do |username|
  @user = Factory(:user, :username => username.trim_quotes)
end
Given /^the (.*) account does (?:not|NOT) exist$/ do |username|
  User.find_by_username(username.trim_quotes).should be_nil
end


Given /^the (.*) account exists$/ do |username|
  Factory(:user, :username => username.trim_quotes, :email => "craig#{rand(1000000)}@example.com")
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
  @user.should_not be_nil
  table.rows_hash.each do |prop, val|
    @user.send((prop+'=').to_sym, val)
    @user.send(prop.to_sym).should == val
  end
  @user.save!
end
Given /^the (.*) account has the following details:$/ do |username, table|
  @user = User.find_by_username(username.trim_quotes)
  table.rows_hash.each do |prop, val|
    @user.send((prop+'=').to_sym, val)
    @user.send(prop.to_sym).should == val
  end
  @user.save!
end
