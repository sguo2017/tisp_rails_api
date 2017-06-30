class AddCallSwitchToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :switch_to, :boolean, :default =>true
    add_column :users, :call_from, :string
    add_column :users, :call_to, :string
  end
end
