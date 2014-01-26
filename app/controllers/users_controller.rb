class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_filter :authenticate_user!

  def home
  end

  def about
  end


	def index
    #@users = User.all
    #@users = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    #@users = User.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    #@users = User.all.order("created_at DESC")

    @search = User.search do
      fulltext params[:search]
      paginate page: 1, per_page: 1000
    end
    @users = @search.results

  end

  def show
    #@conversation_items = current_user.conversation.paginate(page: params[:page])
    #@conversation_items = current_user.conversation
    #@conversation_items = @user.conversation(current_user).paginate(page: params[:page], :per_page => 10)

    #this if-else is so that when a user is not communicating with another one then the conversation items should not show anything
    if ((current_user.communicating?(current_user, @user).any? or @user.communicating?(current_user, @user).any?))
      @conversation_items = @user.conversation(current_user).paginate(page: params[:page], :per_page => 10)
    else
      @conversation_items = @current_user.conversation(current_user).paginate(page: params[:page], :per_page => 10)
    end
    #@conversation_items = conversation(current_user, @user)
  end

  def user_micropost
    @user = User.find(params[:id])
    @micropost = current_user.microposts.build
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
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
      params.require(:user).permit(:name, :image, :password, :password_confirmation, :description, :location)
      #params.require(:user).permit(:image, :password, :password_confirmation, :description, :location)
    end
    
end