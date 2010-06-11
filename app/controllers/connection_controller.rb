class ConnectionController < ApplicationController

  def create
    @user = User.find_first_by_username(params[:user])
    if @user and current_user
      current_user.follow(@user, params[:network])
      redirect_to :back
    else
      # This should not happen unless the followee has disabled their account, or someone is directly POSTing to the URL.
      # So we don't care if the error message is just plain text.
      render :text => "You must specify a user to follow!"
    end
  end

  def destroy
    @user = User.find_first_by_username(params[:user])
    if @user and current_user and current_user.following?(@user, params[:network])
      current_user.unfollow(@user, params[:network])
      redirect_to :back
    else
      # This should not happen unless someone is directly POSTing to the URL.
      # So we don't care if the error message is just plain text.
      render :text => "Cannot delete that connection! #{current_user.username} #{@user.username} #{params[:network]} #{current_user.following?(@user, params[:network])}"
    end
  end

end
