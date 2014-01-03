class EavesdropsController < ApplicationController
  before_action :set_eavesdrop, only: [:show, :edit, :update, :destroy]

  # GET /eavesdrops
  # GET /eavesdrops.json
  def index
    @eavesdrops = Eavesdrop.all
  end

  # GET /eavesdrops/1
  # GET /eavesdrops/1.json
  def show
  end

  # GET /eavesdrops/new
  def new
    @eavesdrop = Eavesdrop.new
  end

  # GET /eavesdrops/1/edit
  def edit
  end

  # POST /eavesdrops
  # POST /eavesdrops.json

  #@user = User.find(params[:relationship][:responder_id])

  def create
    @eavesdrop = Eavesdrop.new(eavesdrop_params)
    #@pin = Pin.find([:eavesdrop][:initiator_id][:responder_id])
    #@pin = Pin.where("initiator_id = (?) AND responder_id = (?)", @eavesdrop.initiator_id, @eavesdrop.responder_id)
    #where("user_id IN (?) OR user_id = ?", responder_user_ids, user)

    respond_to do |format|
      if @eavesdrop.save
        #flash[:notice] = "You are now eavesdropping on this conversation"
        format.html { redirect_to root_url, notice: 'You are now eavesdropping on this conversation' }
        #format.html { redirect_to @eavesdrop.user, notice: 'You are now eavesdropping on this conversation' }
        #format.html { redirect_to url_for(:controller => :pins, :action => :show), notice: 'You are now eavesdropping on this conversation' }
        format.json { render action: 'show', status: :created, location: @eavesdrop }
      else
        #format.html { redirect_to @pin }
        format.html { render action: 'new' }
        format.json { render json: @eavesdrop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eavesdrops/1
  # PATCH/PUT /eavesdrops/1.json
  def update
    respond_to do |format|
      if @eavesdrop.update(eavesdrop_params)
        #format.html { redirect_to @pin, notice: 'You are now eavesdropping on this conversation' }
        format.html { redirect_to @eavesdrop, notice: 'Eavesdrop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_url }
        #format.html { render action: 'edit' }
        format.json { render json: @eavesdrop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eavesdrops/1
  # DELETE /eavesdrops/1.json
  def destroy
    @eavesdrop.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'You are no long eavesdropping on the conversation'  }
      #format.html { redirect_to @eavesdrop.user }
      #format.html { redirect_to eavesdrops_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eavesdrop
      @eavesdrop = Eavesdrop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eavesdrop_params
      params.require(:eavesdrop).permit(:user_id, :initiator_id, :responder_id)
    end
end
