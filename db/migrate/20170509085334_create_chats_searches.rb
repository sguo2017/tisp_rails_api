class CreateChatsSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :chats_searches do |t|
      t.integer :chat_id
      t.integer :order_id
      t.string :chat_content
      t.integer :user_id
      t.string :chat_catalog
      t.string :chat_created

      t.timestamps
    end
  end
end
