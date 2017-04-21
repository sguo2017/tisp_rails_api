class Api::Chat::ChatsController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  # GET /chats
  # GET /chats.json

  def index
    @deal_id = params[:deal_id].presence
    #@chats = Chat.find_by(deal_id: @deal_id.to_s)
    @chats = Chat.where('deal_id ='+@deal_id.to_s).order("created_at DESC")
    logger.debug "chats1 :#{@chats.to_json}"
    @chat_list = []
    @chats.each do |chat|
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
         @chat_list.push(c)
    end

    logger.debug "msgs:#{@chats.to_json}"

    respond_to do |format|
      format.json {
        logger.debug "Chat index json"
        render json: {messages: @chat_list.to_json}
      }
    end

  end

  # GET /chats/1
  # GET /chats/1.json
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat, notice: 'Deal chat detail was successfully created.' }
        #format.json { render :show, status: :created, location: @chat }
        format.json {
                render json: {status:0, msg: "成功"}
        }
      else
        format.html { render :new }
        #format.json { render json: @chat.errors, status: :unprocessable_entity }
        format.json {
       		render json: {status:0, msg: "失败"}
        }
      end
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: 'Deal chat detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Deal chat detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_params
      params.require(:chat).permit(:deal_id, :chat_content, :user_id, :catalog)
    end
end
