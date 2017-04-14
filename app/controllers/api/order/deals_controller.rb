class Api::Order::DealsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user_from_token!
 
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  # GET /deals
  # GET /deals.json
  def index
    @deals = Deal.page(params[:page]).per(5)
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
  end

  # GET /deals/new
  def new
    @deal = Deal.new
  end

  # GET /deals/1/edit
  def edit
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = Deal.new(deal_params)
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    @deal.request_user_id = user.id
    @deal.status = '00A'
    @deal.connect_time = Time.new
    logger.debug "deal:#{@deal}"
    respond_to do |format|
      if @deal.save
        @deal_chat = DealChat.new()
        @deal_chat.deal_id = @deal.id
        @deal_chat.serv_offer_id = @deal.serv_offer_id        
        @deal_chat.offer_user_id = @deal.offer_user_id
        @deal_chat.request_user_id = @deal.request_user_id
        @deal_chat.lately_chat_content = "your offer is awesome"
        @deal_chat.save
        format.html { redirect_to @deal, notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deals/1
  # PATCH/PUT /deals/1.json
  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.json
  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to deals_url, notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal
      @deal = Deal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_params
      params.require(:deal).permit(:serv_offer_title, :serv_offer_id, :offer_user_id, :request_user_id, :status, :connect_time, :deal_time, :finish_time)
    end
end
