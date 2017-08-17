class Api::Chats::ChatMessagesController < ApplicationController
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
    @chat_room = ChatRoom.find(params[:chat_room_id])
    logger.debug "聊天室：#{@chat_room.to_json}"
    @chat_messages = @chat_room.chat_messages.order(created_at: :desc).page(params[:page]).per(5)
    logger.debug "消息：#{@chat_messages.to_json}"
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
