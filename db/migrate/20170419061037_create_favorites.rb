class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.integer :obj_id
      t.string :obj_type
      t.integer :user_id

      t.timestamps
    end
  end
end
