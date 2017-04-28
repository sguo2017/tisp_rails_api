class AddLevelToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :level, :integer, default: 1
  end
end
