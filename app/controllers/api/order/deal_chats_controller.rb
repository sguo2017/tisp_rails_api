class Api::Order::DealChatsController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!
  
  before_action :set_deal_chat, only: [:show, :edit, :update, :destroy]

  def index
    @deal_chats = DealChat.page(params[:page]).per(5)
    @chats = []
    @deal_chats.each do |chat|
         c = chat.attributes.clone
        # u = User.find(chat.user_id)
        # u.authentication_token = "***"
        # c["user"]=u
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
      params.require(:deal_chat).permit(:deal_id, :serv_offer_id, :serv_offer_user_name, :serv_offer_titile, :lately_chat_content)
    end
end


