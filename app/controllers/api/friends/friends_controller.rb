require 'open-uri'
require 'net/http'
class Api::Friends::FriendsController < ApplicationController
	respond_to :json

  before_action :authenticate_user_from_token!
	before_action :set_friend, only: [:show, :edit, :update, :destroy]
  #friends_controller属版本V2
  # GET /friends
  # GET /friends.json
  #场景1：查找已添加的好友
  #场景2：查找待验证的好友
  #场景3：查找客户
  def index
    qry_type = params[:qry_type].presence
    user_id = params[:user_id].presence
    if qry_type == Const::FRIEND_QRY_TYPE[:created]
      @friends = Friend.where("catalog = ? and status = ? and user_id = ?", Const::RELATION_TYPE[:friend], Const::FRIEND_STATUS[:created], user_id).or(Friend.where("status = ? and user_id = ?", Const::FRIEND_STATUS[:recommended], user_id)).order("created_at DESC").page(params[:page]).per(10)
    elsif qry_type == Const::FRIEND_QRY_TYPE[:pending]
      @friends = Friend.where("catalog = ? and status = ? and user_id = ?", Const::RELATION_TYPE[:friend], Const::FRIEND_STATUS[:pending], user_id).order("created_at DESC").page(params[:page]).per(10)     
    elsif qry_type == Const::FRIEND_QRY_TYPE[:customer]
       @friends = Friend.where("catalog = ? and user_id = ?", Const::RELATION_TYPE[:customer], user_id).order("created_at DESC").page(params[:page]).per(10)     
    end
    @friends_arr = []
    @friends.each do |friend|
      f = friend.attributes.clone
      begin
        u = User.find(friend.friend_id)
        u.authentication_token = "***"
        f["avatar"]=u.avatar
        #加载客户列表时，如果客户用户状态是已注册，则客户状态也更新为created
        if friend.status == Const::FRIEND_STATUS[:unjoined] && u.status == Const::USER_STATUS[:created]
          f["status"] = Const::FRIEND_STATUS[:created]
          friend.status = Const::FRIEND_STATUS[:created]
          friend.save
        end
      rescue ActiveRecord::RecordNotFound => e

      end
      @friends_arr.push(f)
    end
    respond_to do |format|
      format.json {
        render json: {page: @friends.current_page, total_pages: @friends.total_pages, feeds: @friends_arr.to_json}
      }
    end
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  def create
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)

    @friend = Friend.new(friend_params)
    if @friend.friend_id
      @user = User.find(@friend.friend_id)
    else
      @user = User.find_by_num(@friend.friend_num)
    end
    #添加已注册用户为好友
    if @user && @user.status == Const::USER_STATUS[:created]
      @friend.status = Const::FRIEND_STATUS[:apply]
      @other = Friend.create!(user_id:@user.id, friend_id: user.id, friend_name:user.name, friend_num:user.num, status: Const::FRIEND_STATUS[:pending])
    #添加别人推荐过的未加入用户为好友
    elsif @user
      logger.debug "用户已被推荐但未加入"
      @friend.status = Const::FRIEND_STATUS[:unjoined]
    else
      logger.debug "用户未加入"
      if @friend.catalog == Const::RELATION_TYPE[:customer]
        #推荐客户
        @friend.status = Const::FRIEND_STATUS[:unjoined]
        @user = User.create!(num: @friend.friend_num, name: @friend.friend_name, status: Const::USER_STATUS[:recommended],email: @friend.friend_num+"@qike.com",password: "888888")
        @user.avatar = img_kit(@user.name.last)
        @user.save
        @friend.friend_id = @user.id
      else
        #推荐专业人士，默认互为好友，并且发布一条默认服务
        catalog_id = params[:catalog_id].presence
        catalog_name = params[:catalog_name].presence
        catalog = GoodsCatalog.find(catalog_id)
        @friend.status = Const::FRIEND_STATUS[:created]
        @user = User.create!(num: @friend.friend_num, name: @friend.friend_name, status: Const::USER_STATUS[:recommended],email: @friend.friend_num+"@qike.com",password: "888888")
        @user.avatar = img_kit(@user.name.last)
        @user.save
        @other = Friend.create!(user_id: @user.id, friend_id: user.id, friend_name:user.name, friend_num:user.num, status:Const::FRIEND_STATUS[:created])
        @good = Good.create!(user_id: @user.id, serv_title: Const::ServOffer::DEFAULT_TITILE%catalog_name, serv_detail: Const::ServOffer::DEFAULT_DETAIL%user.name, serv_catagory: Const::GOODS_TYPE[:offer],catalog: catalog_name, goods_catalog_id:catalog_id ,serv_images: catalog.image)
        @friend.friend_id = @user.id
      end
      
    end
    respond_to do |format|
      if @friend.save
        format.json {
          render json: {status: 0, feed: @friend, user: @user}
        }
      end
    end
  end

  # POST /friends/friend_list
  def friend_list	
    token = params[:token].presence
    @user = token && User.find_by_authentication_token(token.to_s)

  	list = params[:friends].presence
  	logger.debug "好友列表#{list.to_json}"
  	@new_list = []
  	list = JSON.parse(list.to_json)
  	list.each do |friend_arg|
      friend = Friend.new(friend_arg)
      #如果是已注册的用户，则默认加好友
      @pre_user = User.find_by_num(friend.friend_num)
      if @pre_user && @pre_user.id != @user.id
        friend.status = Const::FRIEND_STATUS[:created]
      else
        next
      end
      #如果已经是好友，则不新建friend
      @pre_friend = @user.friends.find_by_friend_num(friend.friend_num)
      if @pre_friend
        @new_list.push(@pre_friend)
        next
      end
  		
  		friend.save
  		@new_list.push(friend)
  	end

    respond_to do |format|
      format.json {
        render json: {feeds: @new_list}
      }
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  #通过好友验证
  def update
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    respond_to do |format|
      if @friend.update(friend_params)
        #通过好友验证，更新对方好友状态
        if @friend.status == Const::FRIEND_STATUS[:created]
          @others = Friend.where('friend_id =? and user_id =? and catalog =?', user.id, @friend.friend_id, Const::RELATION_TYPE[:friend])
          @others.each do |f|
            f.status = Const::FRIEND_STATUS[:created]
            f.save
          end
        end
        format.json {
          render json: {status: 0 ,msg: "success", feed: @friend}
        }
      else
        format.json {
          render json: {status: -1 ,msg: "failed"}
        }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.status = Const::FRIEND_STATUS[:notfriend]
    if @friend.save
       respond_to do |format|
        format.json {render json: {status:0, msg:"success"}}
      end
    else
      respond_to do |format|
        format.json {render json: {status:-1, msg:"fail"}}
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
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def friend_params
      params.permit(:friend_id, :friend_name, :friend_num, :user_id, :status, :catalog, { friends: [ :user_id, :friend_num, :friend_name] } )
    end
    def good_params
      params.permit(:catalog_id, :catalog_name,)
    end
end
