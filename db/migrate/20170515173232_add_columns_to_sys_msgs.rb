class AddColumnsToSysMsgs < ActiveRecord::Migration[5.0]
  def change
    add_column :sys_msgs, :msg_catalog, :string
    add_column :sys_msgs, :accept_users_type, :string
    add_column :sys_msgs, :accept_users, :string
    add_column :sys_msgs, :status, :string
  end
end
