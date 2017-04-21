json.extract! chat, :id, :deal_id, :chat_content, :user_id, :catalog, :created_at, :updated_at
json.url chat_url(chat, format: :json)
