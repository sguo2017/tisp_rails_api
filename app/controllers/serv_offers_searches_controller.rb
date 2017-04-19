class ServOffersSearchesController < ApplicationController

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /serv_offers_search
   def create
      @serv_offers_search=ServOffersSearch.create!(permit_params)
      redirect_to @serv_offers_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /serv_offers_search/:id
   def show
      @serv_offers_search=ServOffersSearch.find(params[:id])
	  @serv_offers=@serv_offers_search.serv_offers.order("created_at DESC").page(params[:page]).per(10)
      render 'serv_offers/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /serv_offers_search/:id
   def update
      @serv_offers_search=ServOffersSearch.create!(permit_params)
      redirect_to @serv_offers_search
   end
   
   private
     def permit_params
	   params.require(:serv_offers_search).permit(:serv_id,:user_id,:serv_title,:serv_detail,:serv_category,:serv_created,:id)
   end

end
