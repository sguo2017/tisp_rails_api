class CreateFavoritesSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites_searches do |t|
      t.integer :favor_id
      t.integer :obj_id
      t.string :obj_type
      t.integer :user_id
      t.string :favor_created

      t.timestamps
    end
  end
end
