class RenameDealChatDetail < ActiveRecord::Migration[5.0]
  def change
    rename_table :deal_chat_details, :chats
  end
end
