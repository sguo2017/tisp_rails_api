# == Schema Information
#
# Table name: sys_msgs_timelines
#
#  id         :integer          not null, primary key
#  sys_msg_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SysMsgsTimeline < ApplicationRecord
  belongs_to :sys_msg, dependent: :delete
  belongs_to :user, dependent: :delete
end
