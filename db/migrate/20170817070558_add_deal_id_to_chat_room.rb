class AddDealIdToChatRoom < ActiveRecord::Migration[5.0]
  def change
  	add_column :chat_rooms, :deal_id, :integer
  end
end
