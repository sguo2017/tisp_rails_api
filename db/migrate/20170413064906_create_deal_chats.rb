class CreateDealChats < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_chats do |t|
      t.integer :deal_id
      t.integer :serv_offer_id
      t.string :serv_offer_user_name
      t.string :serv_offer_titile
      t.string :lately_chat_content

      t.timestamps
    end
  end
end
