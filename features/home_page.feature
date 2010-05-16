Feature: Home Page

    In order to use the site
    As a user
    I want to visit the home page

    Scenario: User is not logged in.
        Given I am not logged in
        When I go to the home page
        Then I should see "Create your own profile"

    Scenario: User is logged in.
        Given I am logged in
        And I have added my "CraigBuchekTwitter" Twitter account
        When I go to the home page
        Then I should see my name
        And I should see my profile
