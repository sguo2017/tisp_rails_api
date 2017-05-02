class AddLockToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :lock, :boolean, :default => false
  end
end
