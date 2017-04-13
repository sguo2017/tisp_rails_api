json.extract! deal_chat_detail, :id, :deal_id, :chat_content, :user_id, :catalog, :created_at, :updated_at
json.url deal_chat_detail_url(deal_chat_detail, format: :json)
