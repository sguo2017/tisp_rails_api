class AddBidderToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :bidder, :integer
    add_column :order_items, :signature, :integer
  end
end
