class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  layout '_user'

  def create
    user = User.find_for_database_authentication(:email => params[:user][:email])
    return render json: {error: {status:-1}} unless user
    respond_to do |format|
      if user.valid_password?(params[:user][:password])
        sign_in("user", user)
        #user.ensure_authentication_token
        
        if !@current_user 
           @current_user = user
           Thread.current[:tispr_user] = user
           session[:current_tispr_user] = user
        end
        if user.avatar
            session[:user_avatar]=user.avatar
        end
        #logger.debug "serv_offer all!!! current_user: #{@current_user.email}"        
        #logger.debug "serv_offer all!!! thread.tispr_user: #{Thread.current[:tispr_user].email}"        
        #logger.debug "serv_offer all!!! session.tispr_user: #{session[:current_tispr_user].email}"        

        logger.debug "user info: #{user.to_json}"        
        format.json { 
          render json: {token:user.authentication_token, user: user.to_json}
        }
        format.js {
          #render :js => "alert('hello')"    
          redirect_to "/"   
        }
      else
        format.json {
          render json: {error: {status:-1}}
        }
      end
    end
  end

  def destroy
    #current_user.authentication_token = Devise.friendly_token
    
    sign_out(current_user)
    reset_session
    redirect_to(:action=>'new')
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
