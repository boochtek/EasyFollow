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

  def signup_confirmation(params)
    subject     "Welcome to #{SITE_NAME}"
    recipients  params[:email_address]
    from        DO_NOT_REPLY
    sent_on     Time.now.utc

    body :username => params[:username],
         :first_name => params[:first_name],
         :full_name => params[:full_name]
  end
end
