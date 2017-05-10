# == Schema Information
#
# Table name: chats_searches
#
#  id           :integer          not null, primary key
#  chat_id      :integer
#  order_id     :integer
#  chat_content :string(255)
#  user_id      :integer
#  chat_catalog :string(255)
#  chat_created :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ChatsSearch < ApplicationRecord

  def chats
    @chats ||= find_chats
  end
  private
    # 条件搜索
    def find_chats
	    chats=Chat.all
		chats=chats.where("id= ? ",chat_id) if chat_id.present?
		chats=chats.where("deal_id= ? ",order_id) if order_id.present?
		chats=chats.where("chat_content like ? ","%#{chat_content}%") if chat_content.present?
		chats=chats.where("user_id= ? ",user_id) if user_id.present?
		chats=chats.where("catalog like ? ","%#{chat_catalog}%") if chat_catalog.present?
		chats=chats.where("created_at like ? ","%#{chat_created}%") if chat_created.present?
		return chats
	end
end
