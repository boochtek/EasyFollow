class UserController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new # TODO
    render 'user/new'
  end

end
