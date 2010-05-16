class HomeController < ApplicationController

  def index
    @user = current_user
    if @user and @user.accounts.empty?
      # User has not completed Step 2 of the signup process, and needs to add at least 1 network.
      redirect_to signup2_path
    elsif @user
      # If the user is logged in, they should see their own profile as their home page.
      @who = "Your"
      @profile_type = 'my'
      render 'user/profile'
    else
      # If the user is not logged in, show them the main home page, with signup, login, and search options.
      render 'home/index'
    end
  end

end
