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
end