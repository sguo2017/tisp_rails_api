class AddGoodsCountToGoodsCatalog < ActiveRecord::Migration[5.0]
  def change
    add_column :goods_catalogs, :goods_count, :integer
  end
end
