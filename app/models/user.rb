class User < ApplicationRecord
  has_many :serv_offers
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
