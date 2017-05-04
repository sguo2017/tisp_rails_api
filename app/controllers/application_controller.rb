class ApplicationController < ActionController::Base
  #respond_to :html, :json  

  #after_filter :clear_thread_variable

  protect_from_forgery with: :exception

  protect_from_forgery with: :null_session

  attr_accessor :current_user

  def authenticate_user_from_token!
    token = params[:token].presence
    logger.debug "token:#{token.to_s}"
    user = token && User.find_by_authentication_token(token.to_s)
    if user
      logger.debug "Hello world! #{@user}"
      #走token不用重复登录操作——登录操作会触发登录用户的修改，修改会触发token变化
      #sign_in user, store: false
    else
      render json: {error: {status:-1}}
    end
    logger.debug "user is nil"
  end


  def clear_thread_variable
    Thread.current[:tispr_user] = nil
  end

  def current_user
      if @user.nil?
                build_global_user_from_session
            end
      return @user
  end
  
  def build_global_user_from_session
     @session_user = session[:current_tispr_user]
     user_id = @session_user["id"]
     @user = User.find_by_id(user_id.to_i)
  end
  
  #非法访问时的处理
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to goods_path, :alert => exception.message }
	  format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
end



