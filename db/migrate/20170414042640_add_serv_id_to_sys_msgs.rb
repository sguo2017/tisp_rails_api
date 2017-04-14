class AddServIdToSysMsgs < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :serv_id, :integer
  end
end
