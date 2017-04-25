# == Schema Information
#
# Table name: order_items
#
#  id                   :integer          not null, primary key
#  deal_id              :integer
#  serv_offer_id        :integer
#  serv_offer_user_name :string(255)
#  serv_offer_titile    :string(255)
#  lately_chat_content  :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  offer_user_id        :integer
#  request_user_id      :integer
#  bidder               :integer
#  signature            :integer
#

class OrderItem < ApplicationRecord
end
