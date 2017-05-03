class Users::SessionsController < Devise::SessionsController

  layout '_user'
  prepend_before_action :valify_captcha!, only: [:create]
  
  def create
	user = User.find_for_database_authentication(:email => params[:user][:email])
	if user.blank?
	  redirect_to new_user_session_path, :alert => "用户名不存在！"
	elsif user.has_locked?
	  redirect_to new_user_session_path, :alert => "您的账号已被锁定，请明天再试！"
	elsif !user.valid_password?(params[:user][:password])
	  user.add_lock if !user.admin
	  redirect_to new_user_session_path, :alert => "密码错误！您还有#{Const::PASSWORD_ERROR_LIMIT-user.lock}次机会！" if !user.admin
	  redirect_to new_user_session_path, :alert => "密码错误！" if user.admin
	else
	  user.unlock
      sign_in("user", user)
	  config_session(user)
      redirect_to root_path
	end
  end

  def destroy
    super{
	   reset_session
	}
  end
  
  private
    def config_session(user)
	  if !@current_user 
         @current_user = user
         Thread.current[:tispr_user] = user
         session[:current_tispr_user] = user
	  end
      if user.avatar
          session[:user_avatar]=user.avatar
      end
	end
	
	def valify_captcha!
      unless verify_rucaptcha?
        redirect_to new_user_session_path, alert: t('rucaptcha.invalid')
        return
      end
      true
    end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
