class UserController < ApplicationController

  # This is only used for signup step 3.
  def index
    if !current_user
      redirect_to home_path
    else
      @users = User.find(:all, :conditions => ['id != ?', current_user.id], :limit => 5) # TODO: Figure out a better way to determine what users to show.
      render 'signup/step3'
    end
  end

  # Signup page to create a new user account
  def new
    if current_user
      flash[:notice] = 'you are already signed up'
      redirect_to home_path
    else
      @user = User.new
      render 'signup/step1'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.valid?
      @user.save!
      sign_in @user # Log the user in immediately (via Devise).
      flash[:notice] = "Proceeding to Signup Step 2"
      redirect_to home_path
    else
      render 'signup/step1'
    end
  end

end
