# == Schema Information
#
# Table name: sys_msgs_searches
#
#  id           :integer          not null, primary key
#  sys_id       :integer
#  user_name    :string(255)
#  action_title :string(255)
#  action_desc  :string(255)
#  user_id      :integer
#  serv_id      :integer
#  sys_created  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class SysMsgsSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
