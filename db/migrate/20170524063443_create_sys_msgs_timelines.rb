class CreateSysMsgsTimelines < ActiveRecord::Migration[5.0]
  def change
    create_table :sys_msgs_timelines do |t|
      t.integer :sys_msg_id
      t.integer :user_id

      t.timestamps
    end
    add_index :sys_msgs_timelines, :user_id
  end
end
