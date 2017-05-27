# == Schema Information
#
# Table name: sys_msgs_timelines
#
#  id         :integer          not null, primary key
#  sys_msg_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string(255)
#

require 'test_helper'

class SysMsgsTimelineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
