# == Schema Information
#
# Table name: sys_msgs
#
#  id           :integer          not null, primary key
#  user_name    :string(255)
#  action_title :string(255)
#  action_desc  :string(255)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  serv_id      :integer
#

require 'test_helper'

class SysMsgTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
