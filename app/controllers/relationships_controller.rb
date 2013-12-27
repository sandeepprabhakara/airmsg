class RelationshipsController < ApplicationController
before_action :authenticate_user!, only: [:create, :destroy]

  def home
  end

  def about
  end

	def index
  end

  def show
  end

  def create
    @user = User.find(params[:relationship][:responder_id])
    current_user.communicate!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).responder
    current_user.uncommunicate!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
    
end