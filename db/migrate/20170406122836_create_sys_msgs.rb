class CreateSysMsgs < ActiveRecord::Migration[5.0]
  def change
    create_table :sys_msgs do |t|
      t.string :user_name
      t.string :action_title
      t.string :action_desc
      t.integer :user_id

      t.timestamps
    end
  end
end
