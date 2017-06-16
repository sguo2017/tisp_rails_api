class AddFavoriteCountToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :favorites_count, :integer
  end
end
