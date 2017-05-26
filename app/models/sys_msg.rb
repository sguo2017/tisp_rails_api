# == Schema Information
#
# Table name: sys_msgs
#
#  id                :integer          not null, primary key
#  user_name         :string(255)
#  action_title      :string(255)
#  action_desc       :string(255)
#  user_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  serv_id           :integer
#  interval          :string(255)
#  msg_catalog       :string(255)
#  accept_users_type :string(255)
#  accept_users      :string(255)
#  status            :string(255)
#

class SysMsg < ApplicationRecord
  has_many :sys_msgs_timelines, dependent: :delete_all
  has_many :users, through: :sys_msgs_timelines

  after_create :after_created_callback

  def set_accept_users(params_hash = {})
    case self.accept_users_type
    when Const::SysMsg::ACCEPT_USERS_TYPE[:same_city]
      @accept_users_ids = User.all.where("city = ?", User.find(self.user_id).city).map{|u| u.id}
    when Const::SysMsg::ACCEPT_USERS_TYPE[:specify_cities]
      @accept_users_ids = User.all.where(city:  params_hash[:cities]).map{|u| u.id}
    when Const::SysMsg::ACCEPT_USERS_TYPE[:specify_users]
      @accept_users_ids = User.all.where(id:  params_hash[:users]).map{|u| u.id}
    when Const::SysMsg::ACCEPT_USERS_TYPE[:all]
      true
    end
  end

  protected
    def after_created_callback
      return if @accept_users_ids.blank?
      SysMsgsTimeline.transaction do
        @accept_users_ids.each do |id|
          SysMsgsTimeline.create!(:user_id => id, :sys_msg_id => self.id)
        end
      end
    end

end
