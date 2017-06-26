class AddStatusToChats < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :status, :string, :default => "unread"
  end
end
