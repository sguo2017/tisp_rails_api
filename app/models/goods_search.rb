class GoodsSearch < ApplicationRecord

  def goods
    @goods ||= find_goods
  end
  
  private
    # 条件搜索
    def find_goods
	    goods=Good.all
		goods=goods.where("id= ? ",serv_id) if serv_id.present?
		goods=goods.where("user_id= ? ",user_id) if user_id.present?
		goods=goods.where("serv_title like ? ","%#{serv_title}%") if serv_title.present?
		goods=goods.where("serv_detail like ? ","%#{serv_detail}%") if serv_detail.present?
		goods=goods.where("serv_category like ? ","%#{serv_category}%") if serv_category.present?
		goods=goods.where("created_at like ? ","%#{serv_created}%") if serv_created.present?
		return goods
	end
end
