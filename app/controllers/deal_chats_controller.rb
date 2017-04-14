class DealChatsController < ApplicationController
  before_action :set_deal_chat, only: [:show, :edit, :update, :destroy]

  # GET /deal_chats
  # GET /deal_chats.json
  def index
    @deal_chats = DealChat.order("created_at DESC").page(params[:page]).per(5)
  end

  # GET /deal_chats/1
  # GET /deal_chats/1.json
  def show
  end

  # GET /deal_chats/new
  def new
    @deal_chat = DealChat.new
  end

  # GET /deal_chats/1/edit
  def edit
  end

  # POST /deal_chats
  # POST /deal_chats.json
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

  # PATCH/PUT /deal_chats/1
  # PATCH/PUT /deal_chats/1.json
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

  # DELETE /deal_chats/1
  # DELETE /deal_chats/1.json
  def destroy
    @deal_chat.destroy
    respond_to do |format|
      format.html { redirect_to deal_chats_url, notice: 'Deal chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_chat
      @deal_chat = DealChat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_chat_params
      params.require(:deal_chat).permit(:deal_id, :serv_offer_id, :serv_offer_user_name, :serv_offer_titile, :lately_chat_content, :offer_user_id, :request_user_id)
    end
end
