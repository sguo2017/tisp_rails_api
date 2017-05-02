class AddLockToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :lock, :integer, :default => 0
  end
end
