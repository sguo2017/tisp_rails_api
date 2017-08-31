class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :obj_id
      t.integer :user_id
      t.string :obj_type
      t.string :content

      t.timestamps
    end
  end
end
