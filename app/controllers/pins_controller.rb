class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /pins
  # GET /pins.json
  def index
    #@pins = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    @search = Pin.search do
    fulltext params[:search]
    #phrase_slop 1
    #with(:published_at).less_than(Time.zone.now)
    #with(:publish_month, params[:month]) if params[:month].present?
    order_by :created_at, :desc
    end
    @pins = @search.results
    #@conversation_items = @pin.initiator.conversation_list(@pin.initiator, @pin.responder)
  end

  # GET /pins/1
  # GET /pins/1.json
  def show
    @conversation_items = @pin.initiator.conversation_list(@pin.initiator, @pin.responder).paginate(page: params[:page], :per_page => 10)
  end

  # GET /pins/new
  def new
    # @pin = Pin.new
    @pin = current_user.pins.build
  end

  # GET /pins/1/edit
  def edit
  end

  # POST /pins
  # POST /pins.json
  def create
    @pin = current_user.pins.build(pin_params)

    respond_to do |format|
      if @pin.save
        format.html { redirect_to @pin, notice: 'Pin was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pin }
      else
        format.html { render action: 'new' }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pins/1
  # PATCH/PUT /pins/1.json
  def update
    respond_to do |format|
      if @pin.update(pin_params)
        format.html { redirect_to @pin, notice: 'Pin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    @pin.destroy
    respond_to do |format|
      format.html { redirect_to pins_url }
      format.json { head :no_content }
    end
  end

  def consulting_index
    @consulting_pins = Pin.where("category = (?)",1).paginate(page: params[:page], :per_page => 30)
  end

  def gradapplication_index
    @gradapplication_pins = Pin.where("category = (?)",2).paginate(page: params[:page], :per_page => 30)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "Not authorized to edit this pin" if @pin.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_params
      params.require(:pin).permit(:description, :image)
    end
end
