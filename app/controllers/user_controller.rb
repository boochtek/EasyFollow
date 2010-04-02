class UserController < ApplicationController

  # Signup page to create a new user account
  def new
    @user = User.new
    render 'user/signup'
  end

  def create
    @user = User.new # TODO
    render 'user/signup'
  end

end
