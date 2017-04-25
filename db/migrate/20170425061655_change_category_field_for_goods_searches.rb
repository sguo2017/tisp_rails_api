class ChangeCategoryFieldForGoodsSearches < ActiveRecord::Migration[5.0]
  def change
    rename_column :goods_searches, :serv_category, :serv_catagory
  end
end
