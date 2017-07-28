# == Schema Information
#
# Table name: sys_msgs
#
#  id                :integer          not null, primary key
#  user_name         :string(255)
#  action_title      :string(255)
#  action_desc       :string(255)
#  user_id           :integer         1、后端管理员新建系统消息；2、新建[订单]发起人；3、新建[serv]的创建人；                       
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  serv_id           :integer
#  interval          :string(255)
#  msg_catalog       :string(255)
#  accept_users_type :string(255)
#  accept_users      :string(255)
#  status            :string(255)
#  link_user_id      :integer         1、订单创建时接受人
#  order_id          :integer         1、订单创建时订单IDs
#

class SysMsg < ApplicationRecord
  has_many :sys_msgs_timelines, dependent: :delete_all
  has_many :users, through: :sys_msgs_timelines

  after_create :after_created_callback
  #需求时推送的人
  def set_accept_users(params_hash = {})
    case self.accept_users_type
    when Const::SysMsg::ACCEPT_USERS_TYPE[:same_city]
      case self.via
      when Const::SERV_VIA[:local]
        @accept_users_ids = Good.all.where("status = '"+ Const::GOODS_STATUS[:pass] +"' and serv_catagory = '"+Const::GOODS_TYPE[:offer]+"' and (via = 'local' or via = 'all') and goods_catalog_id = ? and city = ? and province = ? and country = ?", self.goods_catalog_id, self.city, self.province, self.country).map{|u| u.user_id}
      when Const::SERV_VIA[:remote]
        @accept_users_ids = Good.all.where("status = '"+ Const::GOODS_STATUS[:pass] +"' and serv_catagory = '"+Const::GOODS_TYPE[:offer]+"' and (via = 'remote' or via = 'all')  and goods_catalog_id = ? ", self.goods_catalog_id).map{|u| u.user_id}
      else
        @accept_users_ids = Good.all.where("status = '"+ Const::GOODS_STATUS[:pass] +"' and serv_catagory = '"+Const::GOODS_TYPE[:offer]+"' and goods_catalog_id = ? and city = ? and province = ? and country = ?", self.goods_catalog_id, self.city, self.province, self.country).map{|u| u.user_id}
      end          
      #@accept_users_ids = User.all.where("city = ?", User.find(self.user_id).city).map{|u| u.id}
    when Const::SysMsg::ACCEPT_USERS_TYPE[:specify_cities]
      @accept_users_ids = User.all.where(city:  params_hash[:cities]).map{|u| u.id}
    when Const::SysMsg::ACCEPT_USERS_TYPE[:specify_users]
      @accept_users_ids = User.all.where(id:  params_hash[:users]).map{|u| u.id}
    else
      @accept_users_ids = []
    end
  end

  protected
    def after_created_callback
      return if @accept_users_ids.blank?
      SysMsgsTimeline.transaction do
        @accept_users_ids.each do |id|
          SysMsgsTimeline.create!(:user_id => id, :sys_msg_id => self.id, :status => Const::SysMsg::STATUS[:created])
        end
      end
    end

end
