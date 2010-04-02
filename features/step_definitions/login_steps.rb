Given /^(?:|I )(?:am logged|log) in$/ do
  login
end
Given /^(?:|I )am logged out$/ do
  logout
end
Given /^(?:|I )am (?:not|NOT) logged in$/ do
  Given 'I am logged out'
end

Given /^(?:|I )(?:am logged|log) in as (.+)$/ do |username|
  # TODO: Snip off dquotes, if neccessary.
  # TODO: Allow looking up user by username or full name.
  Given "the \"#{username}\" user exists"
  login_as(username)
end

Given /^the "([^\"]*)" user exists$/ do |username|
  @user = Factory(:user, :login => username)
end


Then /^I should be logged out$/ do
  Then 'I should NOT be logged in'
end
Then /^I should(| not| NOT) be logged in$/ do |nt|
  user_id = @integration_session.session[:user_id]
  if nt =~ / not/i
    user_id.should be_nil
  else
    user_id.should_not be_nil
  end
end

Given /^the "([^\"]*)" account exists$/ do |user|
  Factory(:user, :login => user)
end
Given /^no "([^\"]*)" account exists$/ do |user|
  User.find_by_login(user).should be_nil
end

Given /^the "([^\"]*)" account has a(?:|n) (.+) of "([^\"]*)"$/ do |user, prop, val|
  User.find_by_login(user).send(prop, val) unless prop == 'password' # We don't support passwords yet.
end



# These are the simplest way to test logging in and out without actually having a User class.
def login
  visit('/home/fake_login')
  @integration_session.session[:user_id].should_not be_nil
end

def logout
  visit('/home/fake_logout')
  @integration_session.session[:user_id].should be_nil
end

# This one requires having a User class.
def login_as(login)
  user = @user || User.find_by_login(login) || Factory(:user, :login => login)
  visit("/home/fake_login?id=#{user.id}")
  user_id = @integration_session.session[:user_id]
  user_id.should == user.id
end


# Fake out login, based on ideas from http://www.jarrodspillers.com/2008/08/22/faking-the-funk-stub-authentication-in-a-rails-rspec-story/.
class HomeController
  def fake_login
    (user = params[:id] ? User.find(params[:id]) : User.new).save(false)
    session[:user_id] = user.id
    render :text => ''
  end
  def fake_logout
    session[:user_id] = nil
    render :text => ''
  end
end

if !defined?(User)
  class User
    def self.find(id)
      self.new
    end
  end
end

class User
  def full_name
    'Fake User'
  end
end