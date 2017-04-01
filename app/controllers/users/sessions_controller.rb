class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  def create
    user = User.find_for_database_authentication(:email => params[:user][:email])
    return render json: {error: {status:-1}} unless user
    respond_to do |format|
      if user.valid_password?(params[:user][:password])
        sign_in("user", user)
        user.ensure_authentication_token
        format.json { 
          render json: {token:user.authentication_token, user_id: user.id}
        }
      else
        format.json {
          render json: {error: {status:-1}}
        }
      end
    end
  end

  def destroy
    current_user.authentication_token = Devise.friendly_token
    sign_out(current_user)
    render json: {success: true}
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
