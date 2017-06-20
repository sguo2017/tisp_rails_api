class AddRequestCountToGoodsCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :goods_catalogs, :request_count, :integer, :default => 0
  end
end
