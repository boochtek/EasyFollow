class HomeController < ApplicationController

  def index
    @user = current_user
    @networks = SocialNetworkSite.all
    if @user and @user.accounts.empty? and request.referrer == signup_url
      redirect_to networks_path
    elsif @user
      render 'user/my_profile'
    else
      render 'home/index'
    end
  end

end
