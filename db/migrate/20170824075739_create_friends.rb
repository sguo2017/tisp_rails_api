class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.integer :friend_id
      t.string :friend_name
      t.string :friend_num
      t.integer :user_id
      t.string :status, :default => "unregistered"

      t.timestamps
    end
  end
end
