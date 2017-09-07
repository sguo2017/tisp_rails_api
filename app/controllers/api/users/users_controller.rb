class Api::Users::UsersController < ApplicationController
	respond_to :json

  # before_action :authenticate_user_from_token!
  before_action :set_user, only: [ :update]
  # GET /users/1
  # GET /users/1.json

  #场景：[发现]好友模糊查询
  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s) 
    extra_parm_s = params[:exploreparams] 
    extra_parm_h = JSON.parse extra_parm_s
    title = extra_parm_h['title']
    @users
    @users = User.where("status =? and id !=?", Const::USER_STATUS[:created], user.id)
    if title!=''
      @users = @users.where("name like ?", "%#{title}%").order("created_at DESC")
    end
    logger.debug "用户搜索结果：#{@users.to_json}"
    respond_to do |format|
      format.json {
        render json: {feeds: @users}
      }
    end
  end

  def show
  	@user = User.find(params[:id])
  	respond_to do |format|
  		if @user
  			format.json {
         	render json: {status:0, user: @user.to_json}
        }
      else
      	format.json {
         	render json: {status:0, user: @user.to_json}
        }
  		end
  	end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.json {
          render json: {status: 0 ,msg: "success"}
        }
      else
        format.json {
          render json: {status: -1 ,msg: "failed"}
        }
      end
    end
  end

  private 
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :status, :email, :password, :name)
    end
end
