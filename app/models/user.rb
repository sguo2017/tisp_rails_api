class User < ApplicationRecord
  has_many :serv_offers
  has_many :sys_msgs
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save :ensure_authentication_token
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :avatar, UserAvatarUploader


  #token为空时自动生成新的token

  def ensure_authentication_token    
     if authentication_token.blank?      		
         self.authentication_token = generate_authentication_token    	
     end  
  end


  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end


end
