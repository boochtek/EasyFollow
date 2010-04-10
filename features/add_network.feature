Feature: Add Network

    In order to connect with others
    As a user
    I want to add networking sites to my account

    Scenario: View my networks
        Given I am logged in
        And I have not joined any networks
        When I go to the networks page
        Then I should see a list of networking sites
        And I should see "Add Network" for each networking site

    Scenario: Add Twitter network
        Given I am logged in
        And I have not joined any networks
        And I go to the networks page
        When I follow "Add Network" within "#Twitter"
        And I authorize this app to access my Twitter account
        Then I should be redirected to the networks page
        And I should see "added the Twitter network"
        And I should see my Twitter account name within "#Twitter"

    Scenario: Trying to add Twitter, but network credentials are incorrect
        Given I am logged in
        And I have not joined any networks
        And I go to the networks page
        When I follow "Add Network" within "#Twitter"
        And I do not authorize this app to access my Twitter account
        Then I should still be on the networks page
        And I should NOT see "added the Twitter network"
