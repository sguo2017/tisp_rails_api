class SysMsgsSearchesController < ApplicationController
  
   before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /sys_msgs_search
   def create
      @sys_msgs_search=SysMsgsSearch.create!(permit_params)
      redirect_to @sys_msgs_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /sys_msgs_search/:id
   def show
      @sys_msgs_search=SysMsgsSearch.find(params[:id])
	  @sys_msgs=@sys_msgs_search.sys_msgs.order("created_at DESC").page(params[:page]).per(10)
      render 'sys_msgs/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /sys_msgs_search/:id
   def update
      @sys_msgs_search=SysMsgsSearch.create!(permit_params)
      redirect_to @sys_msgs_search
   end

   private
     def permit_params
	   params.require(:sys_msgs_search).permit(:sys_id,:user_name,:action_title,:action_desc,:user_id,:serv_id,:sys_created,:id)
   end
end
