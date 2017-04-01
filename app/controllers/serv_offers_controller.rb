class ServOffersController < ApplicationController

  before_filter :authenticate_user_from_token!  

  before_filter :authenticate_user!

  before_action :set_serv_offer, only: [:show, :edit, :update, :destroy]

  # GET /serv_offers
  # GET /serv_offers.json
  def index
    @serv_offers = ServOffer.all
  end

  # GET /serv_offers/1
  # GET /serv_offers/1.json
  def show
  end

  # GET /serv_offers/new
  def new
    @serv_offer = ServOffer.new
  end

  # GET /serv_offers/1/edit
  def edit
  end

  # POST /serv_offers
  # POST /serv_offers.json
  def create
    @serv_offer = ServOffer.new(serv_offer_params)

    respond_to do |format|
      if @serv_offer.save
        format.html { redirect_to @serv_offer, notice: 'Serv offer was successfully created.' }
        format.json { render :show, status: :created, location: @serv_offer }
      else
        format.html { render :new }
        format.json { render json: @serv_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /serv_offers/1
  # PATCH/PUT /serv_offers/1.json
  def update
    respond_to do |format|
      if @serv_offer.update(serv_offer_params)
        format.html { redirect_to @serv_offer, notice: 'Serv offer was successfully updated.' }
        format.json { render :show, status: :ok, location: @serv_offer }
      else
        format.html { render :edit }
        format.json { render json: @serv_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /serv_offers/1
  # DELETE /serv_offers/1.json
  def destroy
    @serv_offer.destroy
    respond_to do |format|
      format.html { redirect_to serv_offers_url, notice: 'Serv offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serv_offer
      @serv_offer = ServOffer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serv_offer_params
      params.require(:serv_offer).permit(:serv_title, :serv_detail, :serv_imges, :serv_catagory)
    end
end
