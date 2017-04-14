class AddRequestUserIdToDealChats < ActiveRecord::Migration[5.0]
  def change
    add_column :deal_chats, :request_user_id, :integer
  end
end
