class Api::Order::DealChatDetailsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user_from_token!

  before_action :set_deal_chat_detail, only: [:show, :edit, :update, :destroy]

  # GET /deal_chat_details
  # GET /deal_chat_details.json

  def index
    @deal_id = params[:deal_id].presence
    logger.debug "deal_id: #{@deal_id.to_s}"
    #@deal_chat_details = DealChatDetail.find_by(deal_id: @deal_id.to_s)
    @deal_chat_details = DealChatDetail.where('deal_id ='+@deal_id.to_s)
    logger.debug "deal_chat_details1 :#{@deal_chat_details.to_json}"
    @chats = []
    @deal_chat_details.each do |chat|
         c = chat.attributes.clone
         @deal = Deal.find(chat.deal_id)
         logger.debug "deal #{@deal}"
         @serv = ServOffer.find(@deal.serv_offer_id)
         @request_user = User.find(@deal.request_user_id)
         @request_user.authentication_token = "***"
         @offer_user = User.find(@deal.offer_user_id)
         @offer_user.authentication_token = "***"         
         c["_id"]=@offer_user.id
         c["name"]=@offer_user.name
         c["avatar"]=@offer_user.avatar
         @chats.push(c)
    end

    logger.debug "msgs:#{@chats.to_json}"


    respond_to do |format|
      format.json {
        logger.debug "DealChatDetail index json"
        render json: {messages: @chats.to_json}
      }
    end

  end

  # GET /deal_chat_details/1
  # GET /deal_chat_details/1.json
  def show
  end

  # GET /deal_chat_details/new
  def new
    @deal_chat_detail = DealChatDetail.new
  end

  # GET /deal_chat_details/1/edit
  def edit
  end

  # POST /deal_chat_details
  # POST /deal_chat_details.json
  def create
    @deal_chat_detail = DealChatDetail.new(deal_chat_detail_params)

    respond_to do |format|
      if @deal_chat_detail.save
        format.html { redirect_to @deal_chat_detail, notice: 'Deal chat detail was successfully created.' }
        format.json { render :show, status: :created, location: @deal_chat_detail }
      else
        format.html { render :new }
        format.json { render json: @deal_chat_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_chat_details/1
  # PATCH/PUT /deal_chat_details/1.json
  def update
    respond_to do |format|
      if @deal_chat_detail.update(deal_chat_detail_params)
        format.html { redirect_to @deal_chat_detail, notice: 'Deal chat detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_chat_detail }
      else
        format.html { render :edit }
        format.json { render json: @deal_chat_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_chat_details/1
  # DELETE /deal_chat_details/1.json
  def destroy
    @deal_chat_detail.destroy
    respond_to do |format|
      format.html { redirect_to deal_chat_details_url, notice: 'Deal chat detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_chat_detail
      @deal_chat_detail = DealChatDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_chat_detail_params
      params.require(:deal_chat_detail).permit(:deal_id, :chat_content, :user_id, :catalog)
    end
end
