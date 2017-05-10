# == Schema Information
#
# Table name: orders_searches
#
#  id               :integer          not null, primary key
#  order_id         :integer
#  serv_offer_title :string(255)
#  serv_offer_id    :integer
#  offer_user_id    :integer
#  request_user_id  :integer
#  status           :string(255)
#  connect_time     :string(255)
#  bidder           :integer
#  signature        :integer
#  order_created    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class OrdersSearch < ApplicationRecord
  def orders
    @orders ||= find_orders
  end
  private
    # 条件搜索
    def find_orders
	    orders=Order.all
		orders=orders.where("id= ? ",order_id) if order_id.present?
		orders=orders.where("serv_offer_title like ? ","%#{serv_offer_title}%") if serv_offer_title.present?
		orders=orders.where("serv_offer_id= ? ",serv_offer_id) if serv_offer_id.present?
		orders=orders.where("offer_user_id= ? ",offer_user_id) if offer_user_id.present?
		orders=orders.where("request_user_id= ? ",request_user_id) if request_user_id.present?
		orders=orders.where("status= ? ",status) if status.present?
		orders=orders.where("connect_time like ? ","%#{connect_time}%") if connect_time.present?
		orders=orders.where("bidder= ? ",bidder) if bidder.present?
		orders=orders.where("signature= ? ",signature) if signature.present?
		orders=orders.where("created_at like ? ","%#{order_created}%") if order_created.present?
		return orders
	end
end
