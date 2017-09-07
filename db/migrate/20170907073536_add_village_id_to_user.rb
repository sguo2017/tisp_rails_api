class AddVillageIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :village_id, :integer
  end
end
