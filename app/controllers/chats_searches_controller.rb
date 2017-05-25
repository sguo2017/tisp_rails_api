class ChatsSearchesController < ApplicationController
  
   before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /chats_search
   def create
      @chats_search=ChatsSearch.create!(permit_params)
      redirect_to @chats_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /chats_search/:id
   def show
      @chats_search=ChatsSearch.find(params[:id])
	  @chats=@chats_search.chats.order("created_at DESC").page(params[:page]).per(10)
      render 'chats/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /chats_search/:id
   def update
      @chats_search=ChatsSearch.create!(permit_params)
      redirect_to @chats_search
   end

   private
     def permit_params
	   params.require(:chats_search).permit(:chat_id, :order_id, :chat_content, :user_id, :chat_catalog, :chat_created, :id)
   end

end
