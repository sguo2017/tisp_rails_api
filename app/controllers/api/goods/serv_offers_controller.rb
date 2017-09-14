class Api::Goods::ServOffersController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  before_action :set_serv_offer, only: [:show, :edit, :update, :destroy]


  # GET /serv_offers
  # GET /serv_offers.json
  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)

    @serv_offers
    user_id = params[:user_id].presence
    qry_type = params[:qry_type].presence
    catalog_id = params[:catalog_id].presence
    serv_id = params[:serv_id].presence
    #个人已存档的需求查询的参数为request
    archived = params[:archived].presence
	extra_parm_s = params[:exploreparams]
	#场景一：按职业模糊查询
	if user_id.nil? && !extra_parm_s.nil? && 'undefined' != extra_parm_s
		extra_parm_h = JSON.parse extra_parm_s
    uids = []
    #查找我的好友
    @friends = Friend.where("user_id=? and status=?",user.id, Const::FRIEND_STATUS[:created])
    #查找我的好友的推荐（好评）用户
    @friends.each do |friend|
      if friend.friend_id.nil?
        next
      end
      begin
        @user = User.find(friend.friend_id)
      rescue ActiveRecord::RecordNotFound => e
      end

      if @user.blank?
        next
      end
      @comments = @user.comments
      @comments.each do |comment|
        uids.push(comment.obj_id)
      end
    end
    #查找我的社区
    @villages=user.villages
    @villages.each do |village|
      @users = village.users
      @users.each do |u|
        uids.push(u.id)
      end
    end
    uids = uids.join(",")
		@serv_offers = Good.where("user_id in (#{uids})")
    @serv_offers = @serv_offers.where("status = ?", Const::GOODS_STATUS[:pass])
    @serv_offers = @serv_offers.where("serv_catagory =?", Const::SysMsg::GOODS_TYPE[:offer])
    #查询参数有title且title不为空
    if extra_parm_h.include?("title") && extra_parm_h['title']!=''
		  @serv_offers = @serv_offers.where("catalog like ?", "%#{extra_parm_h['title']}%").order("created_at DESC").page(params[:page]).per(5) 
    else
      @serv_offers = @serv_offers.order("created_at DESC").page(params[:page]).per(5) 
    end

    #场景三：某[二级分类]相关服务查询
  elsif user_id.nil? && catalog_id
    logger.debug "查找分类为#{catalog_id}"
    @target_user = Good.find(serv_id).user
    #serv_id不为空时是查看服务的相关服务
    #serv_id为空时是查看需求的相关服务
    if serv_id 
      @serv_offers = Good.where("id != ? and status = ? and goods_catalog_id = ? and serv_catagory = ?", serv_id, Const::GOODS_STATUS[:pass], catalog_id, Const::SysMsg::GOODS_TYPE[:offer]).order("created_at DESC").page(params[:page]).per(4) 
    else
      @serv_offers = Good.where("status = ? and goods_catalog_id = ? and serv_catagory = ?", Const::GOODS_STATUS[:pass], catalog_id, Const::SysMsg::GOODS_TYPE[:offer]).order("created_at DESC").page(params[:page]).per(4) 
    end
  
  #场景二：全部查询
	elsif user_id.nil?
    if (qry_type == Const::SERV_QRY_TYPE[:offer])
      @serv_offers = Good.where("serv_catagory =?", Const::SysMsg::GOODS_TYPE[:offer])
    elsif (qry_type == Const::SERV_QRY_TYPE[:request])
      @serv_offers = Good.where("serv_catagory =?", Const::SysMsg::GOODS_TYPE[:request])
    else
      @serv_offers = Good.order("created_at DESC")
		end
    @serv_offers =@serv_offers.where("status =?", Const::GOODS_STATUS[:pass]).order("created_at DESC").page(params[:page]).per(5)
    
  #场景四：个人查询
  else
      if(qry_type == Const::SERV_QRY_TYPE[:offer])#我的->服務
        @serv_offers = Good.where(" serv_catagory =? and user_id = ? and status != ? ", Const::SysMsg::GOODS_TYPE[:offer], user_id, Const::GOODS_STATUS[:destroy]).order("created_at DESC").page(params[:page]).per(5)
        @size = 0 #Good.where(" serv_catagory =? and user_id = ?", Const::SysMsg::GOODS_TYPE[:offer], user_id).size;
      elsif(qry_type == Const::SERV_QRY_TYPE[:request])#我的->需求
        if(archived)
           @favorites = Favorite.where("user_id = ? and obj_type = ?", user.id, Const::SysMsg::GOODS_TYPE[:request]).order("created_at DESC").page(params[:page]).per(5)
           @requests = []
           logger.debug "收藏的需求#{@favorites.to_json}"
           @favorites.each do |favorite|
              offer = Good.find(favorite.obj_id)
              s = offer.attributes.clone
              s["isFavorited"] = true
              s["favorite_id"] = favorite.id.to_s
              r = Report.where("user_id = ? and obj_id = ? and obj_type = ?", user.id, offer.id, "good").first
              if r.blank?
                s["isReported"] = false
              else
                s["isReported"] = true
                s["report_id"] = r["id"].to_s
              end
              s["user"]=user
             @requests.push(s)
          end
          respond_to do |format|
            format.json {
              render json: {page: @favorites.current_page, total_pages: @favorites.total_pages, feeds: @requests.to_json}
            }
          end
          return
        else
          @serv_offers = Good.where("serv_catagory =? and user_id = ? and status != ? and not exists (select obj_id from favorites f where f.obj_id = goods.id) ", Const::SysMsg::GOODS_TYPE[:request], user_id, Const::GOODS_STATUS[:destroy]).order("created_at DESC").page(params[:page]).per(5)  
          @size = 0 #Good.where(" serv_catagory =? and user_id = ? and status != ? ", Const::SysMsg::GOODS_TYPE[:request], user_id, Const::GOODS_STATUS[:destroy]).size;
        end      
      else
        @serv_offers = Good.where("user_id = ? and status != ? ", user_id, Const::GOODS_STATUS[:destroy]).order("created_at DESC").page(params[:page]).per(5)
      end
  end



    @offers = []
    @serv_offers.each do |offer|
      s = offer.attributes.clone
      begin
        u = User.find(offer.user_id)
        u.authentication_token = "***"
        s["user"]=u
      rescue ActiveRecord::RecordNotFound => e

      end

      #是否推荐（好评）
      c = Comment.where("user_id = ? and obj_id= ? and status = ?", user.id, u.id, "good").first
      if c.blank?
        s["isRecommanded"] = false
      else
        s["isRecommanded"] = true
      end
      #是否收藏
      f = Favorite.where("user_id = ? and obj_id = ?", user.id, offer.id).first
      if f.blank?
        s["isFavorited"] = false
      else
        s["isFavorited"] = true
        s["favorite_id"] = f["id"].to_s
      end

      #是否举报
      r = Report.where("user_id = ? and obj_id = ? and obj_type = ?", user.id, offer.id, "good").first
      if r.blank?
        s["isReported"] = false
      else
        s["isReported"] = true
        s["report_id"] = r["id"].to_s
      end

      s["created_at"] = s["created_at"].strftime('%Y-%m-%d %H:%M:%S')
      s["updated_at"] = s["updated_at"].strftime('%Y-%m-%d %H:%M:%S')
      @offers.push(s)
    end

    respond_to do |format|
      format.json {
        render json: {page: @serv_offers.current_page, total_pages: @serv_offers.total_pages, feeds: @offers.to_json, count: @size ? @size : 0}
      }
    end

  end

  # GET /serv_offers/1
  # GET /serv_offers/1.json
  def show
  end

  # GET /serv_offers/new
  def new
    @serv_offer = Good.new
  end

  # GET /serv_offers/1/edit
  def edit
  end

  # POST /serv_offers
  # POST /serv_offers.json
  def create
    @serv_offer = Good.new(serv_offer_params)
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    @serv_offer.user_id = user.id
    respond_to do |format|
      avaliable = avaliable_goods_to_add(user, @serv_offer.serv_catagory)
      if avaliable < 1
        format.json {
           render json: {status:-2, msg:"您今天创建数量已达上限！"}
        }
      elsif @serv_offer.save
        if @serv_offer.serv_catagory == Const::SysMsg::GOODS_TYPE[:offer]
          @catalog =GoodsCatalog.where("id = ?", @serv_offer.goods_catalog_id).first
          @catalog.goods_count = @catalog.goods_count + 1
          @catalog.save
          user.offer_count = user.offer_count + 1
          user.save
        elsif @serv_offer.serv_catagory == Const::SysMsg::GOODS_TYPE[:request]
          @catalog =GoodsCatalog.where("id = ?", @serv_offer.goods_catalog_id).first
          if @catalog.request_count 
            @catalog.request_count = @catalog.request_count + 1
          else
            @catalog.request_count = 1
          end
          @catalog.save
          user.request_count =user.request_count + 1
          user.save
        end
        
        format.json {
           render json: {status:0, msg:"success", avaliable: avaliable - 1}
        }
      else
        format.json { render json: @serv_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /serv_offers/1
  # PATCH/PUT /serv_offers/1.json
  def update
    respond_to do |format|
      if @serv_offer.update(serv_offer_params)
        format.html { redirect_to @serv_offer, notice: 'Serv offer was successfully updated.' }
        format.json { 
          render json: {status:0, msg:"success"}
        }
      else
        format.html { render :edit }
        format.json {
          render json: { status: -1 }
        }
      end
    end
  end

  # DELETE /serv_offers/1
  # DELETE /serv_offers/1.json
  def destroy
    # @serv_offer.destroy
    @serv_offer.status = Const::GOODS_STATUS[:destroy]
    if @serv_offer.save
      respond_to do |format|
        # format.html { redirect_to serv_offers_url, notice: 'Serv offer was successfully destroyed.' }
        format.json {render json: {status:0, msg:"success"}}
      end
    else
      respond_to do |format|
        # format.html { redirect_to serv_offers_url, notice: 'Serv offer was successfully destroyed.' }
        format.json {render json: {status:-1, msg:"fail"}}
      end
    end

  end

  def avaliable_goods_to_add(user,serv_catagory)
    has_added = user.goods.where("created_at >= ? and serv_catagory = ?", Time.now.beginning_of_day, serv_catagory).size 
    limit = 0
    limit = 10 if user.level == 1
    limit = 20 if user.level == 2
    limit = 30 if user.level == 3
    limit = has_added + 1 if user.admin #管理员无限制
    avaliable = limit - has_added
    logger.debug "157:#{avaliable}"
    return avaliable
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_serv_offer
      @serv_offer = Good.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def serv_offer_params
      params.require(:serv_offer).permit(:serv_title, :serv_detail, :serv_images, :serv_catagory, :catalog, :goods_catalog_id, :user_id, :district, :city, :province, :country, :latitude, :longitude, :via, :status, :range)
    end
end
