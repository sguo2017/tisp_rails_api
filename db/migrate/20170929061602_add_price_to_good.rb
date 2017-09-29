class AddPriceToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :price, :float
    add_column :goods, :unit, :string, :default => "hour"
    add_column :goods, :change_price, :bool, :default => false
  end
end
