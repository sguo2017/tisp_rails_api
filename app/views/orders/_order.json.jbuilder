json.extract! order, :id, :serv_offer_title, :serv_offer_id, :offer_user_id, :request_user_id, :status, :connect_time, :order_time, :finish_time, :created_at, :updated_at
json.url order_url(order, format: :json)
