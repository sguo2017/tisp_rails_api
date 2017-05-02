class Users::SessionsController < Devise::SessionsController

  layout '_user'
  
  def create
	super {
	  config_session(self.resource)
	}
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


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
