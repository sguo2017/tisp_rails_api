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

	protected
	  def after_created_callback
			request_user = User.find(self.request_user_id)
			case self.status
			when Const::SysMsg::ORDER_STATUS[:inquiried]
				action_title = Const::SysMsg::ACTION_TITLE_OF_INQUIRIED_ORDER%request_user.name
				action_desc = ''
			when Const::SysMsg::ORDER_STATUS[:offered]
				action_title = Const::SysMsg::ACTION_TITLE_OF_OFFERED_ORDER%request_user.name
				action_desc = User.find(request_user_id).name
			when Const::SysMsg::ORDER_STATUS[:confirmed]
				action_title = Const::SysMsg::ACTION_TITLE_OF_CONFIRMED_ORDER%request_user.name
				action_desc = User.find(request_user_id).name
			else
				return
			end
			params_hash = {
				:action_title => action_title,
				:action_desc => action_desc,
				:user_id => request_user.id,
				:user_name => request_user.name,
				:serv_id => self.serv_offer_id,
				:accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:all],
				:msg_catalog => Const::SysMsg::CATALOG[:public],
				:status => Const::SysMsg::STATUS[:created]
			}
			SysMsg.create!(params_hash)
		end
end
