class ConnectionController < ApplicationController

  def create
    @user = User.find_first_by_username(params[:user])
    @network = params[:network]
    if params[:submit] == 'Cancel'
      redirect_to :back
    elsif @user and current_user and @network
      current_user.follow(@user, @network)
      if current_user.following?(@user, @network)
        flash[:notice] = "Successfully added connection to #{@user.username} on #{@network}"
      else
        flash[:notice] = "Sorry, unable to connect to #{@user.username} on #{@network}"
      end
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

  def list
    @user = User.find_first_by_username(params[:user])
    if @user and current_user
      render 'connections/edit', :layout => false
    else
      # This should not happen unless someone is directly accessing the URL, so we don't care if the error message is just plain text.
      render :text => "Cannot view connections! #{current_user.username} #{@user.username}"
    end
  end

  # Considered calling this update, but we're really setting which networks we're connecting on.
  def set
    @user = User.find_first_by_username(params[:user])
    @networks = params[:networks]
    @networks_to_follow = []
    @networks_to_unfollow = []
    SocialNetworkSite.all.each do |network|
      @networks_to_follow   << network if @networks[network.name] == '1' and !current_user.following?(@user, network)
      @networks_to_unfollow << network if @networks[network.name] == '0' and current_user.following?(@user, network)
    end
    current_user.follow(@user, @networks_to_follow)     unless @networks_to_follow.empty?
    current_user.unfollow(@user, @networks_to_unfollow) unless @networks_to_unfollow.empty?
    flash[:notice] = ''
    flash[:notice] += "Successfully added connection to #{@user.username} on #{@networks_to_follow.join(', ')}. "    unless @networks_to_follow.empty?
    flash[:notice] += "Successfully removed connection to #{@user.username} on #{@networks_to_unfollow.join(', ')}." unless @networks_to_unfollow.empty?
    if request.xhr?
      render :nothing => true, :status => 204 # Let jQuery know that we successfully set the connections.
    else
      redirect_to profile_path(@user.username)
    end
  end

end
