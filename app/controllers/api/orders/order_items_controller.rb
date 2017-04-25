class Api::Orders::OrderItemsController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!
  
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    #@order_items = OrderItem.page(params[:page]).per(5)
    @order_items = OrderItem.where('offer_user_id ='+user.id.to_s).or(OrderItem.where('request_user_id ='+ user.id.to_s)).page(params[:page]).per(5)
    logger.debug "order_items:#{@order_items.to_json}"
    @chats = []
    @order_items.each do |chat|
         c = chat.attributes.clone
         logger.debug "deal_id #{chat.deal_id}"
         @deal = Deal.find(chat.deal_id)
         logger.debug "deal #{@deal}"
         @serv = ServOffer.find(@deal.serv_offer_id)
         @request_user = User.find(@deal.request_user_id)
         @request_user.authentication_token = "***"
         @offer_user = User.find(@deal.offer_user_id)
         @offer_user.authentication_token = "***"
         c["request_user"]=@request_user.name
         c["offer_user"]=@offer_user.name
         c["serv"]=@serv.serv_title
         @chats.push(c)
    end

    logger.debug "chats:#{@chats.to_json}"

    respond_to do |format|
      format.json {      
        render json: {page: @order_items.current_page, total_pages: @order_items.total_pages, feeds: @chats.to_json}
      }
    end

  end

  def show
  end

  def new
    @order_item = OrderItem.new
  end

  def edit
  end

  def create
    @order_item = OrderItem.new(order_item_params)

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @order_item, notice: 'Deal chat was successfully created.' }
        format.json { render :show, status: :created, location: @order_item }
      else
        format.html { render :new }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to @order_item, notice: 'Deal chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to order_items_url, notice: 'Deal chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def order_item_params
      params.require(:order_item).permit(:deal_id, :serv_offer_id, :serv_offer_user_name, :serv_offer_titile, :lately_chat_content, :offer_user_id, :request_user_id)
    end
end