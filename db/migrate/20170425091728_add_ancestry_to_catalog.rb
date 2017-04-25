class AddAncestryToCatalog < ActiveRecord::Migration[5.0]
  def change
    add_column :goods_catalogs, :ancestry, :string
    add_index :goods_catalogs, :ancestry
  end
end
