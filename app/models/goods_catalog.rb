class GoodsCatalog < ApplicationRecord
    has_ancestry
	has_many :goods
end

