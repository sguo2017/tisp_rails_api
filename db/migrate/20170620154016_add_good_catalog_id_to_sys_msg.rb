class AddGoodCatalogIdToSysMsg < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :goods_catalog_id, :integer
  end
end
