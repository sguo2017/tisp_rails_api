# == Schema Information
#
# Table name: goods_catalogs
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  level       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ancestry    :string(255)
#  goods_count :integer          default(0)
#

class GoodsCatalog < ApplicationRecord
    has_ancestry
	has_many :goods
end

