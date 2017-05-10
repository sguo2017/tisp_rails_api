# == Schema Information
#
# Table name: sms_sends_searches
#
#  id           :integer          not null, primary key
#  sms_id       :integer
#  recv_num     :string(255)
#  send_content :string(255)
#  state        :string(255)
#  sms_type     :string(255)
#  user_name    :string(255)
#  sms_created  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SmsSendsSearch < ApplicationRecord
  def sms_sends
    @sms_sends ||= find_sms_sends
  end
  
  private
    # 条件搜索
    def find_sms_sends
	    sms_sends=SmsSend.all
		sms_sends=sms_sends.where("id= ? ",sms_id) if sms_id.present?
		sms_sends=sms_sends.where("recv_num like ? ","%#{recv_num}%") if recv_num.present?
		sms_sends=sms_sends.where("send_content like ? ","%#{send_content}%") if send_content.present?
		sms_sends=sms_sends.where("state = ? ","%#{state}%") if state.present?
		sms_sends=sms_sends.where("created_at like ? ","%#{sms_created}%") if sms_created.present?
		if user_name.present?
		   #父节点名称匹配对应的id数组
		   uids=User.all.where("name like ? ","%#{user_name}%").map{|x| x.id}
		   #根据id数组做子集查询
		   sms_sends=sms_sends.where(:user_id => uids)
		end
		return sms_sends
	end
end
