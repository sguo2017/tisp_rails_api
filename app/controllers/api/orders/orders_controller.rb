class Api::Orders::OrdersController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  # 场景一：个人信息里全部订单 personal
  # 场景二：邀标订单 bidder
  def index
    token = params[:token].presence
    scence = params[:scence].presence
    if scence == "personal"
      user = token && User.find_by_authentication_token(token.to_s)
      @orders = Order.where('offer_user_id ='+user.id.to_s).or(Order.where('request_user_id ='+ user.id.to_s)).order("updated_at DESC").page(params[:page]).per(5)
    end
    if scence == "bidder"
      serv_offer_id = params[:serv_id].presence
      @orders = Order.where('serv_offer_id ='+ serv_offer_id).order("updated_at DESC")
      @order_list = []
      @orders.each do |order|
        o = order.attributes.clone
        @offer_user = User.find(order.offer_user_id)
        o["offer_user_avatar"]=@offer_user.avatar
        @order_list.push(o)
      end
      respond_to do |format|
        format.json {
          render json: {feeds: @order_list.to_json}
        }
      end
    elsif scence == "personal"
      @order_list = []
      @orders.each do |order|
        o = order.attributes.clone

        @request_user = User.find(order.request_user_id)
        @request_user.authentication_token = "***"
        @offer_user = User.find(order.offer_user_id)
        @offer_user.authentication_token = "***"
        o["request_user"]=@request_user.name
        o["request_user_avatar"]=@request_user.avatar
        o["request_user_num"]=@request_user.num
        o["offer_user"]=@offer_user.name
        o["offer_user_avatar"]=@offer_user.avatar
        o["offer_user_num"] = @offer_user.num
        o["deal_id"]=order.id
        o["serv_offer_user_name"]=@offer_user.name
        o["updated_at"]=o["updated_at"].strftime('%Y-%m-%d %H:%M:%S')
        
        r1 = Report.where('user_id = ? and obj_id =? and obj_type = ?', user.id, order.request_user_id, "user").first
        r2 = Report.where('user_id = ? and obj_id =? and obj_type = ?', user.id, order.offer_user_id, "user").first

        if r1.blank? && r2.blank?
          o["is_reported"] = false
        else
          o["is_reported"] = true
        end

      #查找订单对方发出的消息，如果最近一条的消息为未读，聊天状态标记为未读
        @chat_room = ChatRoom.find_by_deal_id(order.id)
        if @chat_room.blank?
          @chat_room = ChatRoom.create!(deal_id: order.id, sender_id: order.offer_user_id, recipient_id: order.request_user_id)
        end
        if order.request_user_id.to_s ==  user.id.to_s
        @chat = @chat_room.chat_messages.where('user_id = ?',order.offer_user_id.to_s).order("created_at DESC")
        else
        @chat = @chat_room.chat_messages.where('user_id = ?', order.request_user_id.to_s).order("created_at DESC")          
        end
        if @chat.blank?
          o["chat_status"]=Const::SysMsg::STATUS[:read]
        elsif Const::SysMsg::STATUS[:unread] == @chat.first.status
          o["chat_status"]=Const::SysMsg::STATUS[:unread]
        else
          o["chat_status"]=Const::SysMsg::STATUS[:read]
        end

        @order_list.push(o)
      end

      respond_to do |format|
        format.json {
          render json: {page: @orders.current_page, total_pages: @orders.total_pages, feeds: @order_list.to_json}
        }
      end
    end    
    

  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)

    @order.request_user_id = user.id
    @order.status = Const::SysMsg::ORDER_STATUS[:inquiried]
    @order.connect_time = Time.new
    respond_to do |format|
      avaliable = avaliable_orders_to_add(user)
      if avaliable < 1
        format.json {
           render json: {status:-2, msg:"您今天创建订单数量已达上限！"}
        }
      elsif @order.save
        @offer_user = User.find(@order.offer_user_id)
        o = @order.attributes.clone
        o["request_user"]=user.name
        o["request_user_avatar"]=user.avatar
        o["offer_user"]=@offer_user.name
        o["offer_user_avatar"]=@offer_user.avatar
        o["deal_id"]=@order.id
        o["serv_offer_user_name"]=@offer_user.name

        @chat_room = ChatRoom.create!(deal_id: @order.id, sender_id: user.id, recipient_id: @order.offer_user_id)
        @chat_room.chat_messages.create(user_id: user.id, message: @order.lately_chat_content)

        format.json {
           render json: {status:0, msg:"success",feed: o, avaliable:avaliable-1}
        }
      else
        format.json {
           render json: {status:-1, msg:"fail"}
        }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.json {
           render json: {status:0, msg:"success"}
        }
      else
        #format.json { render json: @order.errors, status: :unprocessable_entity }
        format.json {
           render json: {status:-1, msg:"fail"}
        }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def avaliable_orders_to_add(user)
    has_added = Order.where("created_at >= ? and (request_user_id = ?)", Time.now.beginning_of_day, user.id,).size    
    limit = 0
    limit = 10 if user.level == 1
    limit = 20 if user.level == 2
    limit = 30 if user.level == 3
    limit = has_added + 1 if user.admin #管理员无限制
    avaliable = limit - has_added
    return avaliable
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:serv_offer_title, :serv_offer_id, :offer_user_id, :request_user_id, :status, :connect_time, :bidder, :signature, :lately_chat_content, :serv_catagory)
    end
end
