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
#

class User < ApplicationRecord
  has_many :goods
  has_many :sys_msgs
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save :ensure_authentication_token
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


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


end
