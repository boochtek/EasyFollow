class ProfileController < ApplicationController

  def show
    @username = params[:username]
    @user = User.find_first_by_username(@username)
    @networks = SocialNetworkSite.all
    if @user.nil?
      flash[:error] = "Could not find the #{@username} user."
      redirect_to home_path and return
    elsif current_user.nil?
      @who = "#{@username}'s"
      @profile_type = 'public'
    elsif current_user.username == @username
      @who = "Your"
      @profile_type = 'my'
    else
      @who = "#{@username}'s"
      @profile_type = 'their'
    end
    render 'user/profile'
  end

  def edit
    @bio = current_user.bio || Bio.new
    render 'profile/edit'
  end

  def update
    @bio = current_user.bio
    @bio = Bio.create(:user => current_user) if @bio.nil?
    if @bio.update_attributes(params[:bio])
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to(my_profile_path)
    else
      render 'profile/edit'
    end
  end

end
