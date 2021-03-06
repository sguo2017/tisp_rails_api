class Users::PasswordsController < Devise::PasswordsController
  layout 'unauthorized'
  prepend_before_action :valify_captcha!, only: [:create]
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super{
	  config_session(self.resource)
	}
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  private
    def valify_captcha!
      unless verify_rucaptcha?
        redirect_to new_user_password_path, alert: t('rucaptcha.invalid')
        return
      end
      true
    end
	
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
end
