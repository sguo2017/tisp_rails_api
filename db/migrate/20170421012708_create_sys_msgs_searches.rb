class CreateSysMsgsSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :sys_msgs_searches do |t|
      t.integer :sys_id
      t.string :user_name
      t.string :action_title
      t.string :action_desc
      t.integer :user_id
      t.integer :serv_id
      t.string :sys_created

      t.timestamps
    end
  end
end
