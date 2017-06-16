class AddGoodIdToFavorite < ActiveRecord::Migration[5.0]
  def change
    add_column :favorites, :good_id, :integer
  end
end
