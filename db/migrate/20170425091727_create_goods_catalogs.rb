class CreateGoodsCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :goods_catalogs do |t|
      t.string :name
      t.string :image
      t.integer :level

      t.timestamps
    end
  end
end
