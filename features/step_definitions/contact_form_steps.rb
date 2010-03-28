def dquote(string)
  '"' + string + '"'
end


Then /^my feedback should be emailed to the site admins$/ do
  name = 'Happy Customer'
  address = 'happy@customer.com'
  comment = 'I love this site!'
  Then dquote(EMAIL_FEEDBACK_TO) + ' should receive 1 email'
  When dquote(EMAIL_FEEDBACK_TO) + ' opens the email with subject ' + dquote("#{SITE_NAME} feedback from #{name}")
  Then 'they should see ' + dquote(address) + ' in the email body'
  Then 'they should see ' + dquote(comment) + ' in the email body'
end

Then /^my feedback should NOT be emailed to the site admins$/ do
  Then dquote(EMAIL_FEEDBACK_TO) + ' should receive no emails'
end
