class AddRegistIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :regist_id, :integer
    add_column :users, :device_type, :string
  end
end
