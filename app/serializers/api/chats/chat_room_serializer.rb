class Api::Chats::ChatRoomSerializer < ActiveModel::Serializer
	
  attributes :chat_room_id, :sender_id, :recipient_id

  def chat_room_id
    object.id
  end
end
