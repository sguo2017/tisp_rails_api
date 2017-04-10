json.extract! sys_msg, :id, :user_name, :action_title, :action_desc, :user_id, :created_at, :updated_at
json.url sys_msg_url(sys_msg, format: :json)
