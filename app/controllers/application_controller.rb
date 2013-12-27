class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?


  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @conversation_items = current_user.conversation.paginate(page: params[:page])

    end
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


  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) << :name
  	devise_parameter_sanitizer.for(:account_update) << :name
  end
end
