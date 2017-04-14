class AddOfferUserIdToDealChats < ActiveRecord::Migration[5.0]
  def change
    add_column :deal_chats, :offer_user_id, :integer
  end
end
