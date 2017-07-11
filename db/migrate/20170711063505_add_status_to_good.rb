class AddStatusToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :status, :string, :default => "00X"
  end
end
