Feature: Contact Form

    In order to get my questions answered, or offer feedback
    As a user
    I want to submit feedback on the contact form

# NOTE: Requires rspec-email plugin (http://github.com/bmabey/email-spec)

    Scenario: User fills out contact form correctly.
        Given I start at the home page
        When I go to the contact page
        And I fill in the following:
            | Name           | Happy Customer     |
            | Email Address  | happy@customer.com |
            | Comment        | I love this site!  |
        And do not check the "I am not a human" box
        Then I should get redirected to the home page
        And I should see "Thanks for your feedback!"
        And my feedback should be emailed to the site admins
        

    Scenario: User fills out contact form incorrectly.
        Given I start at the home page
        When I go to the contact page
        And I fill in the following:
            | Name           | Happy Customer    |
            | Email Address  |                   |
            | Comment        | I love this site! |
        And do not check the "I am not a human" box
        Then I should still be on the contact page
        And I should NOT see "Thanks for your feedback!"
        And my feedback should NOT be emailed to the site admins

    Scenario: User is really a bot.
        Given I start at the home page
        When I go to the contact page
        And I fill in the following:
            | Name           | Mean Old Spammer |
            | Email Address  | bot@spammer.com  |
            | Comment        | Buy our junk!    |
        And check the "I am not a human" box
        Then I should get redirected to the home page
        And I should see "Sorry, we only accept feedback from humans"
        And my feedback should NOT be emailed to the site admins
