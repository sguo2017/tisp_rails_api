class GoodsSearchesController < ApplicationController
   before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /goods_search
   def create
      @goods_search=GoodsSearch.create!(permit_params)
      redirect_to @goods_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /goods_search/:id
   def show
      @goods_search=GoodsSearch.find(params[:id])
	  @goods=@goods_search.goods.order("created_at DESC").page(params[:page]).per(10)
      render 'goods/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /goods_search/:id
   def update
      @goods_search=GoodsSearch.create!(permit_params)
      redirect_to @goods_search
   end
   
   private
     def permit_params
	   params.require(:goods_search).permit(:serv_id,:user_id,:serv_title,:serv_detail,:serv_catagory,:serv_created,:id)
   end

end
