class ChangeAncestryFieldForGoods < ActiveRecord::Migration[5.0]
  def change
    rename_column :goods, :ancestry, :good_catagory
  end
end
