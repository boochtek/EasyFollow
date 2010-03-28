Then /^my feedback should be emailed to the site admins$/ do
  Then '"admin@example.com" should receive 1 email'
  When '"admin@example.com" opens the email with subject "Feedback from Happy Customer"'
  Then 'they should see "I love this site!" in the email body'
  Then 'they should see "happy@customer.com" in the email body'
end

Then /^my feedback should NOT be emailed to the site admins$/ do
  Then '"admin@example.com" should receive no emails'
end
