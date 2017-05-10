# == Schema Information
#
# Table name: goods_catalogs_searches
#
#  id              :integer          not null, primary key
#  catalog_id      :integer
#  catalog_name    :string(255)
#  catalog_level   :integer
#  catalog_parent  :string(255)
#  goods_count     :integer
#  catalog_created :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class GoodsCatalogsSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
