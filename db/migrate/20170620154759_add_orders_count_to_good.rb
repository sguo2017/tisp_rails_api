class AddOrdersCountToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :orders_count, :integer ,:default => 0
  end
end
