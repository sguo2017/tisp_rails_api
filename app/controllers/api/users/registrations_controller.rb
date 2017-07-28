class Api::Users::RegistrationsController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!,only: [:update]

  before_action :set_user, only: [:update]
  
  # POST /api/users/registrations/  
  # ×¢²á
  def create
    #注册时验证验证码是否正确
    sms_code = params[:user][:code].presence
    num = params[:user][:num].presence
    sms = SmsSend.where("TIMESTAMPDIFF(MINUTE,created_at ,now())<#{Const::SMS_TIME_LIMIT} and sms_type='code' and send_content=? and recv_num =?", sms_code, num).first
    return render json: {error: {status:-1 ,msg: "验证码不正确"}} unless sms

    @user = User.new(user_params)
    #@user.profile = ""
    @pre_user = User.find_by_email(@user.email)
    respond_to do |format|
      if @pre_user
        format.json {render json: {"success": false, status: -2}}
        logger.debug "邮箱已注册：#{@user.email}"
      elsif @user.save
        format.json { render json: {"success": true, token:@user.authentication_token, user_id:@user.id,user: @user.to_json }}
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
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :num, :current_password, :avatar, :profile, :user_id, :district, :city, :province, :country, :latitude, :longitude, :website)
    end

end
