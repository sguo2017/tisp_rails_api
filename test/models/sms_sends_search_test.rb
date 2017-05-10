# == Schema Information
#
# Table name: sms_sends_searches
#
#  id           :integer          not null, primary key
#  sms_id       :integer
#  recv_num     :string(255)
#  send_content :string(255)
#  state        :string(255)
#  sms_type     :string(255)
#  user_name    :string(255)
#  sms_created  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class SmsSendsSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
