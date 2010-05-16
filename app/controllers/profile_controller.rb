class ProfileController < ApplicationController

  def show
    @username = params[:username]
    @user = User.find_first_by_username(@username)
    @networks = SocialNetworkSite.all
    if @user.nil?
      flash[:error] = "Could not find the #{@username} user."
      redirect_to home_path
    elsif current_user.nil?
      render 'user/public_profile'
    elsif current_user.username == @username
      render 'user/my_profile'
    else
      render 'user/their_profile'
    end
  end

  def edit
  end

  def update
  end

end
