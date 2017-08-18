class AddStatusToChatMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_messages, :status, :string, :default => "unread"
  end
end
