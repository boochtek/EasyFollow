class SearchController < ApplicationController

  def index
    @users = User.search(params[:query], params)
  end

end
