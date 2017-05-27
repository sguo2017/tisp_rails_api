# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  name                   :string(255)
#  avatar                 :string(255)
#  admin                  :boolean          default(FALSE)
#  num                    :string(255)
#  level                  :integer          default(1)
#  lock                   :integer          default(0)
#  district               :string(255)
#  city                   :string(255)
#  province               :string(255)
#  country                :string(255)
#  latitude               :string(255)
#  longitude              :string(255)
#  profile                :string(255)
#

class User < ApplicationRecord
  has_many :goods
  has_many :sms_sends
  has_many :sys_msgs_timelines, dependent: :delete_all
  has_many :sys_msgs, through: :sys_msgs_timelines
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save :ensure_authentication_token
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :after_created_callback

  #token为空时自动生成新的token
  #通过登录修改登录次数来触发token更新，避免token是静态。后面可以改判断时间周期：一天前登录就失效
  def ensure_authentication_token
     if authentication_token.blank?
         #self.authentication_token = generate_authentication_token
     end

     self.authentication_token = generate_authentication_token

    logger.debug "authentication_token:#{authentication_token}"
  end


  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def add_lock
	  if self.lock.blank? and self.lock < 0
	     self.lock = 0
	  else
	     self.lock += 1 if !self.admin
	  end
	  self.save
  end

  def lock_it
      self.lock = Const::PASSWORD_ERROR_LIMIT
	  self.save
  end

  def unlock
      self.lock = 0
	  self.save
  end

  def has_locked?
    if !self.admin and self.updated_at >= Time.now.beginning_of_day and self.lock >= Const::PASSWORD_ERROR_LIMIT
	    return true
	  else
	    return false
	  end
  end

  # 转换成json的时候也屏蔽authentication_token字段
  def as_json(options = {})
    super(options.merge({ except: [:authentication_token] }))
  end

  # 重写 Devise::Models::Authenticatable::serializable_hash
  def serializable_hash(options = nil)
    # 调用 Devise::Models::Authenticatable::serializable_hash，
    # 把需要屏蔽的字段加进白名单
    super({:except => [:authentication_token]})
  end

  protected
    def after_created_callback
      if User.all.size > 0
        params_hash={
          :action_title => Const::SysMsg::ACTION_TITLE_OF_REGISTRATION,
          :action_desc => self.profile,
          :user_id => self.id,
          :user_name =>  self.name,
          :accept_users_type => Const::SysMsg::ACCEPT_USERS_TYPE[:all],
          :msg_catalog => Const::SysMsg::CATALOG[:public],
          :status => Const::SysMsg::STATUS[:created]
        }
        SysMsg.create!(params_hash)
        logger.debug "User created callback has been executed!"
      end
    end

end
