class Api::Order::OrdersController < ApplicationController
  respond_to :json

  before_filter :authenticate_user_from_token!
 
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    @orders = Order.where('offer_user_id ='+user.id.to_s).or(Order.where('request_user_id ='+ user.id.to_s)).page(params[:page]).per(5)
    #@orders = Order.page(params[:page]).per(5)
    logger.debug "orders:#{@orders.to_json}"
    @order_list = []
    @orders.each do |order|
         o = order.attributes.clone
         logger.debug "order_id #{order.id}"
         logger.debug "order #{@order}"
         #@serv = ServOffer.find(order.serv_offer_id) rescue nil
         begin
              @serv = ServOffer.find(order.serv_offer_id)     
              o["serv_offer_titile"]=@serv.serv_title 
         rescue ActiveRecord::RecordNotFound => e
              o["serv_offer_titile"]=""
         end
         @request_user = User.find(order.request_user_id)
         @request_user.authentication_token = "***"
         @offer_user = User.find(order.offer_user_id)
         @offer_user.authentication_token = "***"
         o["request_user"]=@request_user.name
         o["request_user_avatar"]=@request_user.avatar
         o["offer_user"]=@offer_user.name
         o["offer_user_avatar"]=@offer_user.avatar
         o["serv"]=@serv.serv_title
         o["deal_id"]=order.id
         o["serv_offer_user_name"]=@offer_user.name
         #o["serv_offer_titile"]=@serv.serv_title
         @order_list.push(o)
    end

    logger.debug "chats:#{@orders.to_json}"

    respond_to do |format|
      format.json {
        render json: {page: @orders.current_page, total_pages: @orders.total_pages, feeds: @order_list.to_json}
      }
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
    @order.status = '00A'
    @order.lately_chat_content = "your offer is awesome"
    @order.connect_time = Time.new
    logger.debug "order:#{@order}"
    respond_to do |format|
      if @order.save
        @order_chat = OrderItem.new()
        @order_chat.deal_id = @order.id
        @order_chat.serv_offer_id = @order.serv_offer_id        
        @order_chat.offer_user_id = @order.offer_user_id
        @order_chat.request_user_id = @order.request_user_id
        @order_chat.lately_chat_content = "your offer is awesome"
        @order_chat.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        #format.json { render :show, status: :created, location: @order }
        format.json {
           render json: {status:0, msg:"success"}
        }
      else
        format.html { render :new }
        #format.json { render json: @order.errors, status: :unprocessable_entity }
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
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:serv_offer_title, :serv_offer_id, :offer_user_id, :request_user_id, :status, :connect_time, :deal_time, :finish_time, :lately_chat_content)
    end
end
