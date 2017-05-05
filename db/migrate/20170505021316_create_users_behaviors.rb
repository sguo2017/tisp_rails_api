class CreateUsersBehaviors < ActiveRecord::Migration[5.0]
  def change
    create_table :users_behaviors do |t|
	  t.integer :user_id
      t.string :from_url
      t.string :request_url
      t.string :os
      t.string :broswer
      t.string :ip
      t.string :geo_position
      t.string :click_positions
      t.datetime :requested_at
      t.datetime :left_at

      t.timestamps
    end
  end
end
