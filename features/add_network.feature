Feature: Add Network

    In order to connect with others
    As a user
    I want to add networking sites to my account

    Scenario: View my networks
        Given I am logged in
        And I have not joined any networks
        When I go to the networks page
        Then I should see a list of networking sites
        And I should see "add network" next to each networking site

    Scenario: Adding a network
        Given I am logged in
        And I have not joined any networks
        And I go to the networks page
        When I click on "add network" next to the "Twitter" network
        Then I should be sent to the add network page
        And I should see "Twitter"
        When I enter my Twitter account info
        Then I should be redirected to the networks page
        And I should see "Twitter network added"
        And I should see my Twitter account name next to the "Twitter" network

    Scenario: Trying to add a network, but network credentials are incorrect
        Given I am logged in
        And I have not joined any networks
        And I go to the networks page
        When I click on "add network" next to the "Twitter" network
        Then I should be sent to the add networks page
        And I should see "Twitter"
        When I enter incorrect Twitter account info
        Then I should still be on the add network page
        And I should NOT see "Twitter network added"
