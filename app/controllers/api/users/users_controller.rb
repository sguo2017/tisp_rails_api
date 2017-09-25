require 'open-uri'
require 'net/http'

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
    extra_parm_h = JSON.parse(extra_parm_s)
    title = extra_parm_h['title']
    @users
    @users = User.where("status =? and id !=? and admin =?", Const::USER_STATUS[:created], user.id, false)
    if title!=''
      @users = @users.where("name like ?", "%#{title}%").order("created_at DESC").page(params[:page]).per(15)
    else
      @users = @users.order("created_at DESC").page(params[:page]).per(15)
    end
    @users_arr =[]
    @users.each do |u|
      a = u.attributes.clone
      size = u.comments.size
      a["comments_count"] = size
      @users_arr.push(a)
    end
    respond_to do |format|
      format.json {
        render json: {page: @users.current_page, total_pages: @users.total_pages, feeds: @users_arr}
      }
    end
  end

  def show
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s) 
  	@user = User.find(params[:id])
    @friend = user.friends.find_by_friend_id(@user.id)
    if @user
      u = @user.attributes.clone
      if @friend && @friend.catalog == Const::RELATION_TYPE[:friend]
        u["friend_status"]=@friend.status
        u["f_id"]=@friend.id
      end
    	respond_to do |format|
  			format.json {
         	render json: {status:0, user: u.to_json}
        }
    	end
    else
      respond_to do |format|
        format.json {
          render json: {status:-1}
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        if @user.avatar == nil
          @user.avatar = img_kit(@user.name.last)
          @user.save
        end
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

  def img_kit(frist_name) 
    url = Const::IMGKIT_SERVLET_ADDRESS + "?frist_name=#{URI::encode(frist_name)}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    response = http.start { |http| http.request(request) }
    re = JSON.parse(response.body)
    return re["image_url"]
  end

  private 
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :status, :email, :password, :name)
    end
end
