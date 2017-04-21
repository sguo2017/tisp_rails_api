class FavoritesSearchesController < ApplicationController
 before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /favorites_search
   def create
      @favorites_search=FavoritesSearch.create!(permit_params)
      redirect_to @favorites_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /favorites/:id
   def show
      @favorites_search=FavoritesSearch.find(params[:id])
	  @favorites=@favorites_search.favorites.order("created_at DESC").page(params[:page]).per(10)
      render 'favorites/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /favorites_search/:id
   def update
      @favorites_search=FavoritesSearch.create!(permit_params)
      redirect_to @favorites_search
   end
   
   private
     def permit_params
	   params.require(:favorites_search).permit(:favor_id,:obj_id,:obj_type,:user_id,:favor_created,:id)
   end
end
