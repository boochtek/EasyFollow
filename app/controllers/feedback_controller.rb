class FeedbackController < ApplicationController

  def new
    @referrer = request.headers['Referer']
  end

  def create
    if defined?(params[:human]) and params[:human] == 'no'
      flash[:notice] = "Sorry, we only accept feedback from humans."
      redirect_to params[:referrer] || home_path
    elsif params[:email_address].blank? || params[:name].blank? || params[:comment].blank?
      flash.now[:error] = "Please fill in all entries of the contact form."
      render :new
    elsif Notifications.deliver_feedback(params)
      flash[:notice] = "Thanks for your feedback!"
      redirect_to params[:referrer] || home_path
    else
      flash.now[:error] = "Sorry, but we could not send the email."
      redirect_to params[:referrer] || home_path
    end
  end

end
