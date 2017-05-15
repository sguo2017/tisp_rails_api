class AddIntervalToSysMsgs < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :interval, :string
  end
end
