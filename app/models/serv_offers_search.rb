class ServOffersSearch < ApplicationRecord

  def serv_offers
    @serv_offers ||= find_serv_offers
  end
  
  private
    # 条件搜索
    def find_serv_offers
	    serv_offers=ServOffer.all
		serv_offers=serv_offers.where("id= ? ",serv_id) if serv_id.present?
		serv_offers=serv_offers.where("user_id= ? ",user_id) if user_id.present?
		serv_offers=serv_offers.where("serv_title like ? ","%#{serv_title}%") if serv_title.present?
		serv_offers=serv_offers.where("serv_detail like ? ","%#{serv_detail}%") if serv_detail.present?
		serv_offers=serv_offers.where("serv_category like ? ","%#{serv_category}%") if serv_category.present?
		serv_offers=serv_offers.where("created_at like ? ","%#{serv_created}%") if serv_created.present?
		return serv_offers
	end
end
