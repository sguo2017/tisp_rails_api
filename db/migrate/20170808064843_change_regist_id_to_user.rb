class ChangeRegistIdToUser < ActiveRecord::Migration[5.0]
  def change
	change_column :users, :regist_id, :string
  end
end
