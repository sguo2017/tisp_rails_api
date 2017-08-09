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

  after_create :after_created_callback

	protected
    def after_created_callback
    	@target_user = User.find(self.receive_user_id)
    	if @target_user.blank?
    		
    	end
      Jpush.singleMsgPushV2(@target_user.regist_id, self.chat_content, Const::JPushTemplate::TYPE[:chat])
    end
end
