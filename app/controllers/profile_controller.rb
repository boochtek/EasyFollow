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
    render 'profile/show'
  end

  def edit
    @bio = current_user.bio || Bio.new
    render 'profile/edit'
  end

  def update
    @bio = current_user.bio
    @bio = Bio.create(:user => current_user) if @bio.nil?
    if password_change_submitted? and current_user.update_attributes(:password => params[:password], :password_confirmation => params[:password_confirmation ])
      flash[:notice] = 'Password was successfully changed. '
    end
    if password_change_submitted? and !current_user.valid?
      flash[:notice] = 'There were problems changing your password.'
      # TODO: Output the errors.
      render 'profile/edit'
    elsif @bio.update_attributes(params[:bio])
      flash[:notice] = (flash[:notice] || '') + 'Profile was successfully updated.'
      redirect_to(my_profile_path)
    else
      render 'profile/edit'
    end
  end

private

  def password_change_submitted?
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    return (!(@password.blank?) and !(password_confirmation.blank?) and !(password == 'Password' && password_confirmation == 'Confirm Password'))
  end

end
