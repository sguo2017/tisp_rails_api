# == Schema Information
#
# Table name: sys_msgs_searches
#
#  id           :integer          not null, primary key
#  sys_id       :integer
#  user_name    :string(255)
#  action_title :string(255)
#  action_desc  :string(255)
#  user_id      :integer
#  serv_id      :integer
#  sys_created  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SysMsgsSearch < ApplicationRecord

  def sys_msgs
    @sys_msgs ||= find_sys_msg
  end
  
  private
    # 条件搜索
    def find_sys_msg
	    sys_msgs=SysMsg.all
		sys_msgs=sys_msgs.where("id= ? ",sys_id) if sys_id.present?
		sys_msgs=sys_msgs.where("user_name like ? ","%#{user_name}%") if user_name.present?
		sys_msgs=sys_msgs.where("action_title like ? ","%#{action_title}%") if action_title.present?
		sys_msgs=sys_msgs.where("action_desc like ? ","%#{action_desc}%") if action_desc.present?
		sys_msgs=sys_msgs.where("user_id= ? ",user_id) if user_id.present?
		sys_msgs=sys_msgs.where("serv_id= ? ",serv_id) if serv_id.present?
		sys_msgs=sys_msgs.where("created_at like ? ","%#{sys_created}%") if sys_created.present?
		return sys_msgs
	end
	
end
