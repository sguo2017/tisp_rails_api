class GoodsCatalogsSearchesController < ApplicationController
 # 创建搜索
   # 创建完成后重定向到#show
   # POST => /goods_catalogs_search
   def create
      @goods_catalogs_search=GoodsCatalogsSearch.create!(permit_params)
      redirect_to @goods_catalogs_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /goods_catalogs/:id
   def show
      @goods_catalogs_search=GoodsCatalogsSearch.find(params[:id])
	  @goods_catalogs=@goods_catalogs_search.goods_catalogs.order("created_at DESC").page(params[:page]).per(10)
      render 'goods_catalogs/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /goods_catalogs_search/:id
   def update
      @goods_catalogs_search=GoodsCatalogsSearch.create!(permit_params)
      redirect_to @goods_catalogs_search
   end
   
   private
     def permit_params
	   params.require(:goods_catalogs_search).permit(:catalog_id, :catalog_name, :catalog_level, :catalog_parent, :goods_count, :catalog_created, :id)
   end
end
