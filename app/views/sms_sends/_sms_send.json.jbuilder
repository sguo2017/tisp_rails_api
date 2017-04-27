json.extract! sms_send, :id, :recv_num, :send_content, :state, :sms_type, :created_at, :updated_at
json.url sms_send_url(sms_send, format: :json)
