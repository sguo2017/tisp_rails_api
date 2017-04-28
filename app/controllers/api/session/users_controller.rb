class Api::Session::UsersController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!,only: [:show,:edit,:update]

  before_action :set_user, only: [:show,:edit,:update]

  # GET /user/1
  # GET /user/1.json
  def show
  end
  
  # POST /user    
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

  # GET /user/1/edit
  def edit
  end

  # PATCH/PUT /user/1
  # PATCH/PUT /user/1.json
  # ¸üÐÂÍ·Ïñ
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.json { render json:{"success":true}}
      else
        format.json { render json:{"success":false}}
      end
    end
  end
  
  def avatar_server_url
    respond_to do |format|
	    format.json {render json: {"server_url":"http://123.56.157.233:9090/FastDFSWeb/servlet/imageUploadServlet"}}
		format.js {render json: {"server_url":"http://123.56.157.233:9090/FastDFSWeb/servlet/imageUploadServlet"}}
		format.html {render json: {"server_url":"http://123.56.157.233:9090/FastDFSWeb/servlet/imageUploadServlet"}}
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
