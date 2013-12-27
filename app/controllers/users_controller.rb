class UsersController < ApplicationController
  before_action :set_user#, only: [:show, :edit, :update, :destroy]

  def home
  end

  def about
  end

	def index
    #@users = User.all
  end

  def show
  end

  def user_micropost
    @user = User.find(params[:id])
    @micropost = current_user.microposts.build
  end

 	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      #@user = current_user
    end

    def correct_user
      #@pin = current_user.pins.find_by(id: params[:id]) Copied from pins controller. need to edit
      redirect_to users_path, notice: "Not authorized to edit this user" if @user.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      #params.require(:pin).permit(:description, :image)
    end
    
end