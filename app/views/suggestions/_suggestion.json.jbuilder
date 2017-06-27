json.extract! suggestion, :id, :content, :user_id, :status, :created_at, :updated_at
json.url suggestion_url(suggestion, format: :json)
