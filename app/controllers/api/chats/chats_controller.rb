class Api::Chats::ChatsController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  # GET /chats
  # GET /chats.json

  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)

    @deal_id = params[:deal_id].presence
    @deal = Order.find(@deal_id)
	
    @chats = Chat.where('deal_id ='+@deal_id.to_s).order("created_at DESC")
    @chat_list = []
    @chats.each do |chat|
      c = chat.attributes.clone  		 
      @chat_user = User.find(chat.user_id)
      c["_id"]=@chat_user.id
      c["name"]=@chat_user.name
      c["avatar"]=@chat_user.avatar		 
      @chat_list.push(c)

      #当获取消息列表的用户不是发送这条消息的用户时，
      #将这条消息的状态标记为已读
      if chat.user_id.to_s == user.id.to_s

      else
        chat.status = Const::SysMsg::STATUS[:read]
        chat.save
      end

    end
    respond_to do |format|
      format.json {
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
      #消息保存时更新订单的最近聊天内容
      if @chat.save
        order = Order.find(@chat.deal_id);
        order.lately_chat_content = @chat.chat_content
        order.save;

        format.html { redirect_to @chat, notice: 'Deal chat detail was successfully created.' }
        format.json {
          render json: {status:0, msg: "成功"}
        }
      else
        format.html { render :new }
        format.json {
       		render json: {status:-1, msg: "失败"}
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