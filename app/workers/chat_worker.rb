class ChatWorker
  include Sidekiq::Worker

  def perform(did, cid, uid, msg)
    logger.debug "Message is being processed:#{did} - #{cid} - #{uid} - #{msg}"
    @order = Order.find(did)
    @order.lately_chat_content = msg
    @order.save
    ChatRoom.find(cid).chat_messages.create(user_id: uid, message: msg, created_at: Time.now)
  end
end
