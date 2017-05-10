# == Schema Information
#
# Table name: users_searches
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  user_email   :string(255)
#  user_name    :string(255)
#  is_admin     :boolean
#  user_level   :integer
#  has_locked   :boolean
#  user_created :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class UsersSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
