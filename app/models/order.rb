# == Schema Information
#
# Table name: orders
#
#  id                  :integer          not null, primary key
#  serv_offer_title    :string(255)
#  serv_offer_id       :integer
#  offer_user_id       :integer
#  request_user_id     :integer
#  status              :string(255)
#  connect_time        :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lately_chat_content :string(255)
#  bidder              :integer
#  signature           :integer
#

class Order < ApplicationRecord
	self.table_name="orders"
	after_create :after_created_callback
	after_save :after_saved_callback

	protected
	  def after_created_callback
	  	#订单创建 产生动态信息
			request_user = User.find(self.request_user_id)
			offer_user = User.find(self.offer_user_id)
			case self.serv_catagory
			when Const::SysMsg::GOODS_TYPE[:request]
				action_title = Const::SysMsg::ACTION_TITLE_OF_REQUEST_ORDER%request_user.name
				action_desc = ''
				user_name = offer_user.name
				user_id = offer_user.id
				link_user_id = request_user.id
				link_user_name = request_user.name
			when Const::SysMsg::GOODS_TYPE[:offer]
				action_title = Const::SysMsg::ACTION_TITLE_OF_OFFERED_ORDER%offer_user.name
				action_desc = self.serv_offer_title
				user_id = request_user.id
				user_name = request_user.name
				link_user_id = offer_user.id
				link_user_name = offer_user.name
			else
				return
			end
			params_hash = {
				:action_title => action_title,
				:action_desc => action_desc,
				:user_id => user_id,
				:user_name => user_name,
				:serv_id => self.serv_offer_id,
				:accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:all],
				:msg_catalog => Const::SysMsg::CATALOG[:public],
				:status => Const::SysMsg::STATUS[:created],
				:order_id => self.id,
				:link_user_id => link_user_id,
				:link_user_name => link_user_name,
			}
			SysMsg.create!(params_hash)


		end

	protected
	  def after_saved_callback
			order_item_params_hash = {
				:deal_id => self.id,
				:serv_offer_id => self.serv_offer_id,
				:offer_user_id => self.offer_user_id,
				:request_user_id => self.request_user_id,
				:lately_chat_content => self.lately_chat_content,
				:bidder => self.bidder,
				:signature => self.signature
			}

			unless self.status_changed?
				return
		  end

		  # logger.debug "74 order.rb>>> #{self.to_json}"

			OrderItem.create!(order_item_params_hash)
			#订单状态变化 产生动态信息（排除新增的场景）
			request_user = User.find(self.request_user_id)
			offer_user = User.find(self.offer_user_id)
			case self.status
			when Const::SysMsg::ORDER_STATUS[:confirmed]
				action_title = Const::SysMsg::ACTION_TITLE_OF_CONFIRMED_ORDER%offer_user.name
				action_desc = ''
			else
				return
			end

			params_hash = {
				:action_title => action_title,
				:action_desc => action_desc,
				:user_id => request_user.id,
				:user_name => request_user.name,
				:link_user_id => offer_user_id,
				:link_user_name => offer_user.name,
				:serv_id => self.serv_offer_id,
				:accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:all],
				:msg_catalog => Const::SysMsg::CATALOG[:public],
				:status => Const::SysMsg::STATUS[:created]
			}
			SysMsg.create!(params_hash)

		end		
end
