class AddNumToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :num, :string
  end
end
