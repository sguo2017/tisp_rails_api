class AddLatelyChatContentToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :lately_chat_content, :string
  end
end
