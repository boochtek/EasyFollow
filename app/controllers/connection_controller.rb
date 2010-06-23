class ConnectionController < ApplicationController

  def create
    @user = User.find_first_by_username(params[:user])
    @network = params[:network]
    if params[:submit] == 'Cancel'
      redirect_to :back
    elsif @user and current_user
      current_user.follow(@user, @network)
      flash[:notice] = "Successfully added connection to #{@user.username} on #{@network}"
      redirect_to :back
    else
      # This should not happen unless the followee has disabled their account, or someone is directly POSTing to the URL.
      # So we don't care if the error message is just plain text.
      render :text => "You must specify a user to follow!"
    end
  end

  def destroy
    @user = User.find_first_by_username(params[:user])
    @network = params[:network]
    if @user and current_user and current_user.following?(@user, @network)
      current_user.unfollow(@user, @network)
      flash[:notice] = "Successfully removed the connection to #{@user.username} on #{@network} (NOTE: We have not removed your connection on #{@network}, just on Meezy)"
      redirect_to :back
    else
      # This should not happen unless someone is directly POSTing to the URL.
      # So we don't care if the error message is just plain text.
      render :text => "Cannot delete that connection! #{current_user.username} #{@user.username} #{params[:network]} #{current_user.following?(@user, params[:network])}"
    end
  end

end
