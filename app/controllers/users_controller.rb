class UsersController < ApplicationController
  def home
  end

  def about
  end

    def whoresponders
    @title = "Responders"
    @user = User.find(params[:id])
    @users = @user.responder_users.paginate(page: params[:page])
    #@users = @user.responders.paginate(page: params[:page])
    render 'microposts/show_communicate'
  end

  def whoinitiators
    @title = "Initiators"
    @user = User.find(params[:id])
    @users = @user.initiators.paginate(page: params[:page])
    render 'microposts/show_communicate'
  end

end