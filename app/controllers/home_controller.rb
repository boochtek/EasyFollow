class HomeController < ApplicationController

  def index
    if current_user
      render 'user/my_profile'
    else
      render 'index'
    end
  end

end
