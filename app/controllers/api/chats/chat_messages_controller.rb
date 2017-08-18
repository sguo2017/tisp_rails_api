class Api::Chats::ChatMessagesController < ApplicationController
  before_action :authenticate_user_from_token!
	# POST /api/chats/chat_rooms/:id/chat_messages
  # Creates a chat message
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @chat_message = @chat_room.chat_messages.build(chat_message_params)
    @chat_message.user_id = current_user.id
    @chat_message.save!

    render json: @chat_message, serializer: ChatMessageSerializer
  end

  # GET /api/chats/chat_rooms/:id/chat_messages/
  # GET messages of a chat room
  def show
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @chat_messages = @chat_room.chat_messages.order(created_at: :desc).page(params[:page]).per(5)
    @chat_list = []
    @chat_messages.each do |chat|
      c = chat.attributes.clone      
      @chat_user = User.find(chat.user_id)
      c["user_name"]=@chat_user.name
      c["user_avatar"]=@chat_user.avatar    
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
          render json: {page: @chat_messages.current_page,total_pages: @chat_messages.total_pages, chat_messages: @chat_messages}
      }
    end
    # render json: @chat_messages, each_serializer: ChatMessageSerializer
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:message)
  end

end
