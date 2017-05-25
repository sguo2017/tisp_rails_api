class OrdersSearchesController < ApplicationController
  
   before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /orders_search
   def create
      @orders_search=OrdersSearch.create!(permit_params)
      redirect_to @orders_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /orders_search/:id
   def show
      @orders_search=OrdersSearch.find(params[:id])
	  @orders=@orders_search.orders.order("created_at DESC").page(params[:page]).per(10)
	  @selected_status=(Const::ORDER_STATUS.select{|x| x[1] == @orders_search.status}).flatten
      render 'orders/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /orders_search/:id
   def update
      @orders_search=OrdersSearch.create!(permit_params)
      redirect_to @orders_search
   end

   private
     def permit_params
	   params.require(:orders_search).permit(:order_id, :serv_offer_title, :serv_offer_id, :offer_user_id, :request_user_id, :status, :connect_time, :bidder, :signature, :order_created, :id)
   end
end
