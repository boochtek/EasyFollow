class Notifications < ActionMailer::Base
  def feedback(params)
    subject     "#{SITE_NAME} feedback from #{params[:name]}"
    recipients  EMAIL_FEEDBACK_TO
    from        params[:email_address]
    sent_on     Time.now.utc

    body :comment => params[:comment], 
         :name => params[:name],
         :email_address => params[:email_address]
  end

  def signup_confirmation(user)
    subject     "Welcome to #{SITE_NAME}"
    recipients  user.email_address
    from        DO_NOT_REPLY
    sent_on     Time.now.utc

    body :user => user
  end
end
