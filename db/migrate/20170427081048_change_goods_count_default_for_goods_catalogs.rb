class ChangeGoodsCountDefaultForGoodsCatalogs < ActiveRecord::Migration[5.0]
  def change
    change_column_default :goods_catalogs, :goods_count, from: nil, to: 0
  end
end
