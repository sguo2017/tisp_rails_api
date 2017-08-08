class AddReceiveUserIdToChat < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :receive_user_id, :integer
  end
end
