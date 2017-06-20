# == Schema Information
#
# Table name: goods
#
#  id               :integer          not null, primary key
#  serv_title       :string(255)
#  serv_detail      :string(255)
#  serv_images       :string(255)
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
#

class Good < ApplicationRecord
  belongs_to :user
  belongs_to :goods_catalog, counter_cache: true
  after_create :after_created_callback
  has_many :favorites
  has_many :orders

  protected
    def after_created_callback
      if self.serv_catagory == Const::SysMsg::GOODS_TYPE[:request]
        params_hash = {
          :user_id => self.user_id,
          :user_name => self.user.name,
          :serv_id => self.id,
          :action_desc => self.serv_title,
          :accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:same_city],
          :msg_catalog => Const::SysMsg::CATALOG[:private],
          :status => Const::SysMsg::STATUS[:created],
          :via => self.via,
          :district => self.district,
          :city => self.city,
          :province => self.province,
          :country => self.country,
          :goods_catalog_id => self.goods_catalog_id
        }
        sys_msg = SysMsg.new(params_hash)
        sys_msg.set_accept_users #设置接受用户为同城人，插入中间表
        sys_msg.save
        logger.debug "Good created callback has been executed!"
      elsif self.serv_catagory == Const::SysMsg::GOODS_TYPE[:offer]
        params_hash={
          :action_title => Const::SysMsg::ACTION_TITLE_OF_USER_CREATE_SERV_OFFER,
          :action_desc => self.serv_title,
          :user_id => self.user_id,
          :user_name => self.user.name,
          :serv_id => self.id,
          :accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:all],
          :msg_catalog => Const::SysMsg::CATALOG[:public],
          :status => Const::SysMsg::STATUS[:created],
          :via => self.via
        }
        sys_msg = SysMsg.create!(params_hash) #公共消息，不需要指定接收人，直接保存
        logger.debug "Good created callback has been executed!"
      end
    end
end
