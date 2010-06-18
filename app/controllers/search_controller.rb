class SearchController < ApplicationController

  def index
    @users = User.search(params[:query], params)
    if current_user
      @users_in_my_network = @users.select{|user| current_user.following?(user)}
      @users_not_in_my_network = @users.reject{|user| current_user.following?(user)}
    end
  end

end
