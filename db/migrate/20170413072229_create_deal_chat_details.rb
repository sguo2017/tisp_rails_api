class CreateDealChatDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_chat_details do |t|
      t.integer :deal_id
      t.string :chat_content
      t.integer :user_id
      t.string :catalog

      t.timestamps
    end
  end
end
