json.extract! serv_offer, :id, :serv_title, :serv_detail, :serv_imges, :serv_catagory, :created_at, :updated_at
json.url serv_offer_url(serv_offer, format: :json)
