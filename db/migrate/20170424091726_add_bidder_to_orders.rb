class AddBidderToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :bidder, :integer
    add_column :orders, :signature, :integer
    remove_column :orders, :deal_time
    remove_column :orders, :finish_time
  end
end
