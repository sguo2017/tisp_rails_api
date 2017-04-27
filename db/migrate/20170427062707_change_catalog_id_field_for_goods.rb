class ChangeCatalogIdFieldForGoods < ActiveRecord::Migration[5.0]
  def change
    rename_column :goods, :catalog_id, :goods_catalog_id
  end
end
