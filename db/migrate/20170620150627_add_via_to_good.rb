class AddViaToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :via, :string, :default => 'local'
  end
end
