# == Schema Information
#
# Table name: goods
#
#  id               :integer          not null, primary key
#  serv_title       :string(255)
#  serv_detail      :string(255)
#  serv_images      :string(2000)
#  serv_catagory    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  catalog          :string(255)
#  goods_catalog_id :integer
#  district         :string(255)
#  city             :string(255)
#  province         :string(255)
#  country          :string(255)
#  latitude         :string(255)
#  longitude        :string(255)
#  status           :string(255)    :default 00A  desc:缺省00A未审核，前端不能查看;00B审核通过，前端可以查看;00D个人删除，个人服务不可查看;00X审核不通过，前端不可以查看

class Good < ApplicationRecord
  belongs_to :user
  belongs_to :goods_catalog, counter_cache: true
  after_save :after_saved_callback
  has_many :favorites
  has_many :reports

  protected
    def after_saved_callback
      if status_changed? 
        @target_user = User.find(self.user_id)
        if self.status == Const::GOODS_STATUS[:pass]
          new_mgs(self)
          Jpush.singleMsgPushV2(@target_user.regist_id, Const::JPushTemplate::GOOD_PASS%self.serv_title)

        elsif self.status == Const::GOODS_STATUS[:reject]
          SysMsg.where(serv_id: self.id).update_all(status: Const::SysMsg::STATUS[:discarded])
          Jpush.singleMsgPushV2(@target_user.regist_id, Const::JPushTemplate::GOOD_REJECT%self.serv_title)
        else

        end  
      end
    end

  private
    def new_mgs(param)
      if param.serv_catagory == Const::SysMsg::GOODS_TYPE[:request]
        params_hash = {
          :user_id => param.user_id,
          :user_name => param.user.name,
          :serv_id => param.id,
          :action_desc => param.serv_title,
          :accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:same_city],
          :msg_catalog => Const::SysMsg::CATALOG[:private],
          :status => Const::SysMsg::STATUS[:created],
          :via => param.via,
          :district => param.district,
          :city => param.city,
          :province => param.province,
          :country => param.country,
          :goods_catalog_id => param.goods_catalog_id
        }
        sys_msg = SysMsg.new(params_hash)
        sys_msg.set_accept_users #设置接受用户为同城人，插入中间表
        sys_msg.save
        logger.debug "Good created callback has been executed!"
      elsif param.serv_catagory == Const::SysMsg::GOODS_TYPE[:offer]
        params_hash={
          :action_title => Const::SysMsg::ACTION_TITLE_OF_USER_CREATE_SERV_OFFER,
          :action_desc => param.serv_title,
          :user_id => param.user_id,
          :user_name => param.user.name,
          :serv_id => param.id,
          :accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:all],
          :msg_catalog => Const::SysMsg::CATALOG[:public],
          :status => Const::SysMsg::STATUS[:created],
          :via => param.via
        }
        sys_msg = SysMsg.create!(params_hash) #公共消息，不需要指定接收人，直接保存
        logger.debug "Good created callback has been executed!"
      end

    end

end
