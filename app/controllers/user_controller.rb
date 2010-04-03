class UserController < ApplicationController

  # Signup page to create a new user account
  def new
    if current_user
      flash[:notice] = 'you are already signed up'
      redirect_to home_path
    else
      @user = User.new
      render 'user/signup'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.valid?
      @user.save!
      session[:user_id] = @user.id # Log the user in right away.
      flash[:notice] = "Proceeding to Signup Step 2"
      redirect_to home_path
    else
      render 'user/signup'
    end
  end

end
