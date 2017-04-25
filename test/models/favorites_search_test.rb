# == Schema Information
#
# Table name: favorites_searches
#
#  id            :integer          not null, primary key
#  favor_id      :integer
#  obj_id        :integer
#  obj_type      :string(255)
#  user_id       :integer
#  favor_created :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class FavoritesSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
