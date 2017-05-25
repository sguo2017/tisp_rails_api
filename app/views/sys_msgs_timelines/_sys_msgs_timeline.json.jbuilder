json.extract! sys_msgs_timeline, :id, :user_id, :sys_msg_id, :created_at, :updated_at
json.url sys_msgs_timeline_url(sys_msgs_timeline, format: :json)
