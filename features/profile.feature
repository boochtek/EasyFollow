Feature: Profile

    In order to connect with others
    As a user (logged in or not)
    I want to see the profiles of other users on the site

    Scenario: Public profile (viewer not logged in)
        Given I am not logged in
        And the CraigBuchek account exists
        And the CraigBuchek account has the following details:
            | first_name | Craig                   |
            | last_name  | Buchek                  |
            | email      | craigbuchek@example.com |
        And CraigBuchek has added his "CraigBuchekTwitter" Twitter account
        When I go to '/CraigBuchek'
        Then I should see "Craig Buchek"
        And I should see "CraigBuchek"
        And I should see "CraigBuchekTwitter"
        And I should NOT see "Follow Me"
        And I should see "Sign up to follow me"
        And I should see their bio
        And I should see their networks
        And I should see their connections

    Scenario: Public profile (with username capitalized differently)
        Given I am not logged in
        And the CraigBuchek account exists
        And the CraigBuchek account has the following details:
            | first_name | Craig                   |
            | last_name  | Buchek                  |
            | email      | craigbuchek@example.com |
        And CraigBuchek has added his "CraigBuchekTwitter" Twitter account
        When I go to '/CRAIGBUCHEK'
        Then I should see "Craig Buchek"
        And I should see "CraigBuchek"
        And I should see "CraigBuchekTwitter"
        And I should NOT see "Follow Me"
        And I should see "Sign up to follow me"
        And I should see their bio
        And I should see their networks
        And I should see their connections

    Scenario: Their profile (viewer logged in)
        Given I am logged in
        And the CraigBuchek account exists
        And the CraigBuchek account has the following details:
            | first_name | Craig                   |
            | last_name  | Buchek                  |
            | email      | craigbuchek@example.com |
        And CraigBuchek has added his "CraigBuchekTwitter" Twitter account
        When I go to '/CraigBuchek'
        Then I should see "Craig Buchek"
        And I should see "CraigBuchek"
        And I should see "CraigBuchekTwitter"
        And I should NOT see "Follow Me"
        And I should NOT see "Sign up"
        And I should see their bio
        And I should see their networks
        And I should see their connections

    Scenario: My profile (viewer viewing his own profile)
        Given I am logged in as CraigBuchek
        And my account has the following details:
            | first_name | Craig                   |
            | last_name  | Buchek                  |
            | email      | craigbuchek@example.com |
        And I have added my "CraigBuchekTwitter" Twitter account
        When I go to '/CraigBuchek'
        Then I should see "Craig Buchek"
        And I should see "CraigBuchek"
        And I should see "CraigBuchekTwitter"
        And I should NOT see "Follow Me"
        And I should NOT see "Sign up"
        And I should see my bio
        And I should see my networks
        And I should see my connections

    Scenario: User does not exist
        Given I am not logged in
        And the CraigBuchek account does not exist
        When I go to '/CraigBuchek'
        Then I should get redirected to the home page
        And I should see "Could not find the CraigBuchek user"
