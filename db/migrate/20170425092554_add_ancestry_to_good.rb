class AddAncestryToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :ancestry, :string
    add_index :goods, :ancestry
  end
end
