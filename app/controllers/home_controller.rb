class HomeController < ApplicationController

  helper_method :local_request?, :consider_all_requests_local, :current_user

  def index
    if current_user
      render 'user/my_profile'
    else
      render 'index'
    end
  end

  def current_user
    session[:user]
  end
end
