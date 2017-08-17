class Api::Chats::ChatRoomsController < ApplicationController
	# POST /api/chats/chat_rooms
  # Creates a chat room
  def create
    unless params[:sender_id] == current_user.id
      puts "Error: current_user.id and sender_id are different"
      return
    end

    chat_room = ChatRoom.where("deal_id = ?", params[:deal_id])
    if chat_room.blank?
      @chat_room = ChatRoom.create!(chat_room_params)
    else
      @chat_room = chat_room.first 
    end

    # render json: @chat_room, serializer: ChatRoomSerializer

    respond_to do |format|
        format.json {
          render json: {chat_room_id: @chat_room.id }
      }
    end
  end

  private

  def chat_room_params
    params.permit(:sender_id, :recipient_id, :deal_id)
  end
end
