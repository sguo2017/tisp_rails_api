class AddUserIdToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :user_id, :integer
  end
end
