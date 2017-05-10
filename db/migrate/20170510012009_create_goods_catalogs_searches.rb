class CreateGoodsCatalogsSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :goods_catalogs_searches do |t|
      t.integer :catalog_id
      t.string :catalog_name
      t.integer :catalog_level
      t.string :catalog_parent
      t.integer :goods_count
      t.string :catalog_created

      t.timestamps
    end
  end
end
