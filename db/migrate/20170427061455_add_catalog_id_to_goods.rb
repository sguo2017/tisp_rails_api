class AddCatalogIdToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :catalog_id, :integer
  end
end
