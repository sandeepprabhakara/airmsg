class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :destroy]

  # GET /microposts
  # GET /microposts.json
  def index
    #@microposts = Micropost.where("user_id = ?", id)
    #@user = User.find(params[:id])
    #@microposts = @user.microposts.paginate(:page => params[:page], :per_page => 5)
    @microposts = Micropost.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    if signed_in?
      @micropost = current_user.microposts.build if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end

  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
    #@user = User.find(params[:id])
    #@microposts = @user.microposts.paginate(page: params[:page])
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
  end

 
  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = Micropost.new(micropost_params)

    respond_to do |format|
      if @micropost.save
        format.html { redirect_to root_url, notice: 'Micropost was successfully created.' }
        format.json { render action: 'show', status: :created, location: @micropost }
        #flash[:success] = "Micropost created!"
        #redirect_to root_url
      else
        format.html { render action: root_url }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
        @feed_items = []
      end
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:content, :user_id, :initiator, :responder, :topic)
    end

    
end
