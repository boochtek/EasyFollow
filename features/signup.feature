Feature: Signup

    In order to use the site to its fullest
    As a user
    I want to sign up for an account

    Scenario: Getting to the signup page
        Given I am not logged in
        When I start at the home page
        And I click on the "get-started" link
        Then I should be on the signup page

    Scenario: User signs up (Step 1)
        Given I have not signed up for an account
        And I am on the signup page
        When I fill out the signup form correctly
        Then I should be logged in
        And I should be in "Step 2" of the signup
        And I should receive an email confirming that I've signed up

    Scenario: User tries to sign up, but is already logged in
        Given I am logged in
        And I have added my "CraigBuchekTwitter" Twitter account
        When I go to the signup page
        Then I should be redirected to the home page or the signup page
        And I should see "you are already signed up"

    Scenario: User tries to sign up, but the selected username is already taken
        # NOTE: Usernames are NOT case sensitive, so the existing name might be capitalized differently than the name entered on the signup form.
        Given I have not signed up for an account
        And I am on the signup page
        When I fill out the signup form
        But I enter a username that is already taken
        Then I should see "has already been taken"
        And I should still be in "Step 1" of the signup

    Scenario: User tries to sign up, but the selected username is restricted
        Given I have not signed up for an account
        And I am on the signup page
        When I fill out the signup form
        But I enter a username that is in the restricted list
        Then I should see "is not allowed"
        And I should still be in "Step 1" of the signup

    Scenario: User tries to sign up, but the selected username contains invalid characters
        Given I have not signed up for an account
        And I am on the signup page
        When I fill out the signup form
        But I enter a username that contains a slash
        Then I should see "may only contain alphanumeric characters, plus"
        And I should still be in "Step 1" of the signup

    Scenario: User tries to sign up, but the entered information is not valid
        # NOTE: This scenario represents any other validation error on the form, such as an invalid email address or not agreeing to the terms.
        Given I have not signed up for an account
        And I am on the signup page
        When I fill out the signup form incorrectly
        Then I should still be in "Step 1" of the signup
        And I should see "problems with the following fields"

#    Scenario: User signed up, but never added any networks
#        Given I am logged in
#        And I have not added any networks
#        When I go to the home page
#        Then I should be redirected to the networks page
#        And I should be in "Step 2" of the signup

