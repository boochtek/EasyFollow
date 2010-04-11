class LoginController < ApplicationController

  def new
    @user = User.create
    render 'login/new'
  end

  def create
    # TODO: We don't have passwords yet, as we may end up using OpenID or something similar.
    @user = User.find(:first, :conditions => ['LOWER(login) = ?', params[:user][:login].downcase]) # NOTE: It'd be better if we just set the collation on this column in the DB to be case-insensitive.
    if @user && @user.verify_password(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to(home_path)
      return
    else
      @user = User.create(params[:user])
      flash[:notice] = 'Incorrect username or password.'
    end
    render 'login/new'
  end

  def delete
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out.'
    redirect_to(home_path)
  end
end
