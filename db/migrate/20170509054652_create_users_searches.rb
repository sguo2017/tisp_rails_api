class CreateUsersSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :users_searches do |t|
      t.integer :user_id
      t.string :user_email
      t.string :user_name
      t.boolean :is_admin
      t.integer :user_level
      t.boolean :has_locked
      t.string :user_created

      t.timestamps
    end
  end
end
