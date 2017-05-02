class Api::Users::RegistrationsController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!,only: [:update]

  before_action :set_user, only: [:update]
  
  # POST /api/users/registrations/  
  # ×¢²á
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.json { render json: {"success": true, token:@user.authentication_token, user_id:@user.id }}
      else
        format.json {render json: {"success": false}}
      end
    end
  end

  # PATCH/PUT /api/users/registrations/:id/ 
  # ¸üÐÂ
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.json { render json:{"success":true}}
      else
        format.json { render json:{"success":false}}
      end
    end
  end
  
  #POST/GET /api/users/image_server_url
  def image_server_url
    respond_to do |format|
	    format.json {render json: {"server_url":Const::IMAGE_UPLOAD_SERVLET_ADDRESS}}
		format.js {render json:  {"server_url":Const::IMAGE_UPLOAD_SERVLET_ADDRESS}}
		format.html {render json:  {"server_url":Const::IMAGE_UPLOAD_SERVLET_ADDRESS}}
	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :user_id)
    end

end
