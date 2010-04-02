Feature: Signup

    In order to use the site to its fullest
    As a user
    I want to sign up for an account

    Scenario: Getting to the signup page
        Given I am not logged in
        When I start at the home page
        And I click on the "create a profile" button
        Then I should be on the signup page

    Scenario: User signs up (Step 1)
        Give I am on the signup page
        When I fill out the signup form correctely
        Then I should receive an email confirming that I've signed up
        And I should be in "Step 2" of the signup

    Scenario: User tries to sign up, but is already logged in
        Given I am not logged in
        When I go to the signup page
        Then I should be redirected to the home page
        And I should see "you are already signed up"

    Scenario: User tries to sign up, but the selected username is already taken
        Give I am on the signup page
        When I fill out the signup form correctely
        But I enter a username that is already taken # NOTE: Usernames are NOT case sensitive
        Then I should see "username is already taken"
        And I should still be in "Step 1" of the signup

    Scenario: User tries to sign up, but the selected username is restricted
        Give I am on the signup page
        When I fill out the signup form correctely
        But I enter a username that is in the restricted list
        Then I should see "username is not allowed"
        And I should still be in "Step 1" of the signup

    Scenario: User tries to sign up, but the selected username contains invalid characters
        Give I am on the signup page
        When I fill out the signup form correctely
        But I enter a username that contains a slash
        Then I should see "username may not contain a slash"
        And I should still be in "Step 1" of the signup

    Scenario: User tries to sign up, but the entered information is not valid
        Give I am on the signup page
        When I fill out the signup form incorrectely # NOTE: This represents any other validation error on the form
        Then I should still be in "Step 1" of the signup

    Scenario: User signed up, but never added any networks
        Give I am logged in
        And I have never added any networks
        When I go to the home page
        Then I should be redirected to the signup page
        And I should be in "Step 2" of the signup

