Given /^(?:|I )(?:am logged|log) in$/ do
  login
end

Given /^(?:|I )am logged out$/ do
  logout
end

Given /^(?:|I )am (?:not|NOT) logged in$/ do
  Given 'I am logged out'
end

Given /^(?:|I )(?:am logged|log) in as (.*)$/ do |username|
  # TODO: Snip off dquotes, if neccessary.
  # TODO: Allow looking up user by username of full name.
  login(username)
end

Then /^(?:|I )should see my name$/ do
  Then 'I should see "Fake User"'
end

Then /^(?:|I )should see my profile$/ do
  Then 'I should see "User Profile"'
end


# These are the simplest way to test logging in and out without actually having a User class.
def login
  visit('/home/fake_login')
end

def logout
  visit('/home/fake_logout')
end


# Fake out login, based on ideas from http://www.jarrodspillers.com/2008/08/22/faking-the-funk-stub-authentication-in-a-rails-rspec-story/.
class HomeController
  def fake_login
    session[:user] = FakeUser.new
    render :text => ''
  end
  def fake_logout
    session[:user] = nil
    render :text => ''
  end
end

class FakeUser
  def full_name
    'Fake User'
  end
end
