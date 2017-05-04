class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  layout 'unauthorized' ,only: [:new]
  prepend_before_action :valify_captcha!, only: [:create]
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

  def index
     build_global_user_from_session
     logger.debug "user#edit***************#{@user.id}"
  end 

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def create
     super
     reset_session
  end

  # GET /resource/edit
  def edit
     build_global_user_from_session
     logger.debug "user#edit***************#{@user.id}"
  end
  
  # PUT /resource
  def update
    #build_global_user_from_session
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, user_params)
    yield resource if block_given?
    if resource_updated
      if @user.avatar
        session[:user_avatar]=@user.avatar
      end
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :avatar)
  end
  
  def valify_captcha!
      unless verify_rucaptcha?
        redirect_to new_user_registration_path, alert: t('rucaptcha.invalid')
        return
      end
      true
  end

end
