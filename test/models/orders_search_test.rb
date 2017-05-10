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

require 'test_helper'

class OrdersSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
