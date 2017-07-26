class AddRangeToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :range, :integer,:default => 0
  end
end
