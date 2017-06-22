class AddOrderCntToGoods < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :order_cnt, :integer, :default => 0
  end
end
