# == Schema Information
#
# Table name: chats
#
#  id           :integer          not null, primary key
#  deal_id      :integer
#  chat_content :string(255)
#  user_id      :integer
#  catalog      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Chat < ApplicationRecord
	self.table_name="chats"
end
