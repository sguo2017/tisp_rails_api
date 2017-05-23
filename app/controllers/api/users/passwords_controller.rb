class Api::Users::PasswordsController < ApplicationController
  respond_to :json
  
  def create
    user = User.find_for_database_authentication(:email => user_params[:email])
	return render json: {error: {status:-1}} unless user
    user.send_reset_password_instructions
    respond_to do |format|
      if successfully_sent?(user)
        format.json { render json:{"success":true}}
      else
        format.json { render json:{"success":false}}
      end
	end
  end
  
  private 
    def user_params
      params.require(:user).permit(:email)
    end
	
	def successfully_sent?(resource)
      notice = if Devise.paranoid
        resource.errors.clear
        :send_paranoid_instructions
      elsif resource.errors.empty?
        :send_instructions
      end

      if notice
        true
      end
    end
  
end