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
      sign_in user, store: false
    end
    logger.debug "user is nil"
  end


  def clear_thread_variable
    Thread.current[:tispr_user] = nil
  end

end



