class ConnectionController < ApplicationController

  def create
    @user = User.find_first_by_username(params[:user])
    if @user
      current_user.follow(@user)
      redirect_to :back
    else
      # This should not happen unless the followee has disabled their account, or someone is directly POSTing to the URL.
      # So we don't care if the error message is just plain text.
      render :text => "You must specify a user to follow!"
    end
  end

end
