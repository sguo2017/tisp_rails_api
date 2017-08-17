class ChatWorker
  include Sidekiq::Worker

  def perform(cid, uid, msg)
    logger.debug "Message is being processed: #{cid} - #{uid} - #{msg}"
    ChatRoom.find(cid).chat_messages.create(user_id: uid, message: msg, created_at: Time.now)
  end
end
