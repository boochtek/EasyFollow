Feature: Following

    In order to connect with others
    As a user
    I want to follow them on all our networking sites

    Scenario: Both of us are on Twitter
        Given I am logged in as CraigBuchek
        And I have added my "CraigBuchekTwitter" Twitter account
        And the BoochTek account exists
        And BoochTek has added the "BoochTekTwitter" Twitter account
        When I go to '/BoochTek'
        And I click on the "Follow Me" button
        And I go to my profile page
        Then I should see "BoochTek" within ".connections"

    Scenario: I'm already following him on Twitter
        Given I am logged in as CraigBuchek
        And I have added my "CraigBuchekTwitter" Twitter account
        And the BoochTek account exists
        And BoochTek has added the "BoochTekTwitter" Twitter account
        And I am already following "BoochTekTwitter" on Twitter
        When I go to '/BoochTek'
        And I click on the "Follow Me" button
        And I go to my profile page
        Then I should see "BoochTek" within ".connections"
