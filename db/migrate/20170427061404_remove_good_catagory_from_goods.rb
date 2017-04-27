class RemoveGoodCatagoryFromGoods < ActiveRecord::Migration[5.0]
  def change
    remove_column :goods, :good_catagory, :string
  end
end
