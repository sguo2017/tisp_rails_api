class RenameDealDetailToOrderItem < ActiveRecord::Migration[5.0]
  def change
    rename_table :deal_chats, :order_items
  end
end
