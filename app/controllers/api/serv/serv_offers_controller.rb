class Api::Serv::ServOffersController < ApplicationController
  respond_to :json

  before_filter :authenticate_user_from_token!

  before_action :set_serv_offer, only: [:show, :edit, :update, :destroy]


  # GET /serv_offers
  # GET /serv_offers.json
  def index
    @serv_offers = ServOffer.all
    logger.debug "serv_offer all!!! current_user:#{@current_user}"
    if user_signed_in?
      logger.debug 'siged_id!!!!!!'
    else
      logger.debug 'why?'
    end

    @offers = []
    @favorites.each do |favorite|
         s = offer.attributes.clone
         u = User.find(offer.user_id)
         u.authentication_token = "***"
         s["user"]=u
         @offers.push(s)
         #logger.debug "m:#{s}"
    end

    logger.debug "msgs:#{@offers.to_json}"


    respond_to do |format|
      format.json {
        logger.debug "sysMsg index json"
        render json: {page: "1",total_pages: "7", feeds: @serv_offers.to_json}
      }
    end
    
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
    
    token = params[:token].presence

    user = token && User.find_by_authentication_token(token.to_s)


    logger.debug "current_user:#{user.email}"   

    @sys_msg = SysMsg.new(:user_name=>user.name, :action_title=>'created an offer', :action_desc=>@serv_offer.serv_title, :user_id=>user.id)
    @sys_msg.user = user 
    
    @serv_offer.user_id = user.id    

    respond_to do |format|
      if @serv_offer.save
        @sys_msg.serv_id = @serv_offer.id
        logger.debug "serv_id:#{@sys_msg.serv_id} id:#{@serv_offer.id}"
        @sys_msg.save
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
      params.require(:serv_offer).permit(:serv_title, :serv_detail, :serv_imges, :serv_catagory, :user_id)
    end
end
