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
	extra_parm_s = params[:exploreparams]
	#场景一：模糊查询
	if user_id.nil? && !extra_parm_s.nil? && 'undefined' != extra_parm_s
		extra_parm_h = JSON.parse extra_parm_s
		@serv_offers = Good.all
    @serv_offers =@serv_offers.where("serv_catagory =?", Const::SysMsg::GOODS_TYPE[:offer]).order("created_at DESC").page(params[:page]).per(5)
    #查询参数有title且title不为空
    if extra_parm_h.include?("title") && extra_parm_h['title']!=''
		  @serv_offers = @serv_offers.where("serv_title like ?", "%#{extra_parm_h['title']}%").order("created_at DESC").page(params[:page]).per(5)
    end
    #查询参数有goods_catalog_id且goods_catalog_id不等于undedined
    if extra_parm_h.include?("goods_catalog_I") && 'undefined' != extra_parm_h['goods_catalog_I']
      @serv_offers = @serv_offers.where("goods_catalog_id in (?)",extra_parm_h['goods_catalog_I']).order("created_at DESC").page(params[:page]).per(5)
    end     
    if extra_parm_h.include?("district")
      @serv_offers = @serv_offers.where("district =? and serv_catagory =?",extra_parm_h['district'], Const::SysMsg::GOODS_TYPE[:offer]).order("created_at DESC").page(params[:page]).per(5)
    end
  #场景二：全部查询
	elsif user_id.nil?
    if (qry_type == Const::SERV_QRY_TYPE[:offer])
      @serv_offers = Good.where("serv_catagory =?", Const::SysMsg::GOODS_TYPE[:offer]).order("created_at DESC").page(params[:page]).per(5)
    elsif (qry_type == Const::SERV_QRY_TYPE[:request])
      @serv_offers = Good.where("serv_catagory =?", Const::SysMsg::GOODS_TYPE[:request]).order("created_at DESC").page(params[:page]).per(5)
    else
    @serv_offers = Good.order("created_at DESC").page(params[:page]).per(5) 
		end
	#场景三：个人查询
  else
      if(qry_type == Const::SERV_QRY_TYPE[:offer])#我的->服務
        @serv_offers = Good.where(" serv_catagory =? and user_id = ?", Const::SysMsg::GOODS_TYPE[:offer], user_id).order("created_at DESC").page(params[:page]).per(5)
        @size = Good.where(" serv_catagory =? and user_id = ?", Const::SysMsg::GOODS_TYPE[:offer], user_id).size;
      elsif(qry_type == Const::SERV_QRY_TYPE[:request])#我的->需求
        @serv_offers = Good.where("serv_catagory =? and user_id = ?", Const::SysMsg::GOODS_TYPE[:request], user_id).order("created_at DESC").page(params[:page]).per(5)  
        @size = Good.where(" serv_catagory =? and user_id = ?", Const::SysMsg::GOODS_TYPE[:request], user_id).size;
      else
        @serv_offers = Good.where("user_id = ?", user_id).order("created_at DESC").page(params[:page]).per(5)
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

         #是否收藏
         f = Favorite.where("user_id = ? and obj_id = ? and obj_type = ?", user.id, offer.id, "serv_offer").first
         if f.blank?
           s["isFavorited"] = false
         else
           s["isFavorited"] = true
           s["favorite_id"] = f["id"].to_s
         end
         @offers.push(s)
         #logger.debug "m:#{s}"
    end

    #logger.debug "发现服务msgs:#{@serv_offers.to_json}"

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
        elsif @serv_offer.serv_catagory == Const::SysMsg::GOODS_TYPE[:request]
          @catalog =GoodsCatalog.where("id = ?", @serv_offer.goods_catalog_id).first
          if @catalog.request_count 
            @catalog.request_count = @catalog.request_count + 1
          else
            @catalog.request_count = 1
          end
          @catalog.save
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
        format.json { render :show, status: :ok, location: @serv_offer }
      else
        format.html { render :edit }
        format.json { render json: @serv_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /serv_offers/1
  # DELETE /serv_offers/1.json
  def destroy
    @serv_offer.destroy
    respond_to do |format|
      format.html { redirect_to serv_offers_url, notice: 'Serv offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def avaliable_goods_to_add(user,serv_catagory)
    has_added = user.goods.where("created_at >= ? and serv_catagory = ?", Time.now.beginning_of_day, serv_catagory).size 
    limit = 0
    limit = 5 if user.level == 1
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
      params.require(:serv_offer).permit(:serv_title, :serv_detail, :serv_images, :serv_catagory, :catalog, :goods_catalog_id, :user_id, :district, :city, :province, :country, :latitude, :longitude)
    end
end
