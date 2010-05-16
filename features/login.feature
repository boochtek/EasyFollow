Feature: Login

    In order to use the site to its fullest
    As a user
    I want to log in

    Scenario: Logging in with correct username and password
        Given I am not logged in
        And the "test" account exists
        And the "test" account has a password of "password"
        When I go to the login page
        And fill in "Username" with "test"
        And fill in "Password" with "password"
        And click on the "Log In" button
        Then I should end up on the home page
        And I should be logged in
        And I should see my name
        And I should see my profile

# FIXME: Devise doesn't support case-insensitive usernames.
#    Scenario: Logging in with username capitalized
#        Given I am not logged in
#        And the "test" account exists
#        And the "test" account has a password of "password"
#        When I go to the login page
#        And fill in "Username" with "TesT"
#        And fill in "Password" with "password"
#        And click on the "Log In" button
#        Then I should end up on the home page
#        And I should be logged in
#        And I should see my name
#        And I should see my profile

    Scenario: Trying to log in with incorrect password
        Given I am not logged in
        And the "test" account exists
        And the "test" account has a password of "password"
        When I go to the login page
        And fill in "Username" with "test"
        And fill in "Password" with "incorrect password"
        And click on the "Log In" button
        Then I should still be on the login page
        And I should see "Incorrect username or password"
        And I should NOT be logged in
        And I should NOT see my profile

    Scenario: Trying to log in to account that doesn't exist
        Given I am not logged in
        And no "test" account exists
        When I go to the login page
        And fill in "Username" with "test"
        And fill in "Password" with "password"
        And click on the "Log In" button
        Then I should still be on the login page
        And I should see "Incorrect username or password"
        And I should NOT be logged in
        And I should NOT see my profile

    Scenario: Logging out
        Given I am logged in
        When I go to the logout page
        Then I should be logged out
        And I should be redirected to the home page
        And I should see "Logged out"
        And I should see "Create your own profile"
