class Api::Order::DealChatsController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!
  
  before_action :set_deal_chat, only: [:show, :edit, :update, :destroy]

  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    #@deal_chats = DealChat.page(params[:page]).per(5)
    @deal_chats = DealChat.where('offer_user_id ='+user.id.to_s).or(DealChat.where('request_user_id ='+ user.id.to_s))
    logger.debug "deal_chats:#{@deal_chats.to_json}"
    @chats = []
    @deal_chats.each do |chat|
         c = chat.attributes.clone
         logger.debug "deal_id #{chat.deal_id}"
         @deal = Deal.find(chat.deal_id)
         logger.debug "deal #{@deal}"
         @serv = ServOffer.find(@deal.serv_offer_id)
         @request_user = User.find(@deal.request_user_id)
         @request_user.authentication_token = "***"
         @offer_user = User.find(@deal.offer_user_id)
         @offer_user.authentication_token = "***"
         c["request_user"]=@request_user.name
         c["offer_user"]=@offer_user.name
         c["serv"]=@serv.serv_title
         @chats.push(c)
    end

    logger.debug "chats:#{@chats.to_json}"

    respond_to do |format|
      format.json {      
        render json: {page: "1",total_pages: "7", feeds: @chats.to_json}
      }
    end

  end

  def show
  end

  def new
    @deal_chat = DealChat.new
  end

  def edit
  end

  def create
    @deal_chat = DealChat.new(deal_chat_params)

    respond_to do |format|
      if @deal_chat.save
        format.html { redirect_to @deal_chat, notice: 'Deal chat was successfully created.' }
        format.json { render :show, status: :created, location: @deal_chat }
      else
        format.html { render :new }
        format.json { render json: @deal_chat.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @deal_chat.update(deal_chat_params)
        format.html { redirect_to @deal_chat, notice: 'Deal chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_chat }
      else
        format.html { render :edit }
        format.json { render json: @deal_chat.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deal_chat.destroy
    respond_to do |format|
      format.html { redirect_to deal_chats_url, notice: 'Deal chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_deal_chat
      @deal_chat = DealChat.find(params[:id])
    end

    def deal_chat_params
      params.require(:deal_chat).permit(:deal_id, :serv_offer_id, :serv_offer_user_name, :serv_offer_titile, :lately_chat_content, :offer_user_id, :request_user_id)
    end
end


