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
  login_as(username)
end


Then /^I should be logged out$/ do
  Then 'I should NOT be logged in'
end
Then /^I should(| not| NOT) be logged in$/ do |nt|
  if nt =~ / not/i
    Then %{I should NOT see "Log Out"}
  else
    Then %{I should see "Log Out"}
  end
end


def login
  Given %{the "test" account exists}
  Given %{the "test" account has a password of "password"}
  When %{I go to the login page}
  When %{fill in "Username" with "test"}
  When %{fill in "Password" with "password"}
  When %{click on the "Log In" button}
  Then %{I should end up on the home page}
  Then %{I should be logged in}
end

def logout
  visit('/logout')
  @integration_session.session[:user_id].should be_nil
end

def login_as(login)
  Given %{the "#{login}" account exists}
  Given %{the "#{login}" account has a password of "password"}
  When %{I go to the login page}
  When %{fill in "Username" with "#{login}"}
  When %{fill in "Password" with "password"}
  When %{click on the "Log In" button}
  Then %{I should end up on the home page}
  Then %{I should be logged in}

#  user = @user || User.find_by_username(login) || Factory(:user, :username => login)
#  visit('/login')

#  user_id = @integration_session.session[:user_id]
#  user_id.should == user.id
end




# Based on code from http://www.francisfish.com/debugging_cucumber_scripts_cucumber_and_devise_authenticati.htm
def create_user(params)
  unless user = User.find_by_username(params[:username])
    params[:password_confirmation] = params[:password]
    user = User.create!(params)
  end
  user
end


if !defined?(User)
  class User
    def self.find(id)
      self.new
    end
    def full_name
      'Fake User'
    end
  end
end
