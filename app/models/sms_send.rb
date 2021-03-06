# == Schema Information
#
# Table name: sms_sends
#
#  id           :integer          not null, primary key
#  recv_num     :string(255)
#  send_content :string(255)
#  state        :string(255)
#  sms_type     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#

class SmsSend < ApplicationRecord
   belongs_to :user
end
