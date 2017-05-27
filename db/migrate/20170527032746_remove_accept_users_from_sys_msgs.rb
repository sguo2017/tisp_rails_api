class RemoveAcceptUsersFromSysMsgs < ActiveRecord::Migration[5.0]
  def change
    remove_column :sys_msgs, :accept_users, :string
  end
end
