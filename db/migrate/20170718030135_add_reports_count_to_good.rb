class AddReportsCountToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :reports_count, :integer, :default => 0
  end
end
