class RenameDealToOrder < ActiveRecord::Migration[5.0]
  def change
    rename_table :deals, :orders
  end
end
