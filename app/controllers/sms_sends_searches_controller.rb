class SmsSendsSearchesController < ApplicationController
  
    before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /sms_sends_search
   def create
      @sms_sends_search=SmsSendsSearch.create!(permit_params)
      redirect_to @sms_sends_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /sms_sends_search/:id
   def show
      @sms_sends_search=SmsSendsSearch.find(params[:id])
	  @sms_sends=@sms_sends_search.sms_sends.order("created_at DESC").page(params[:page]).per(10)
      render 'sms_sends/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /sms_sends_search/:id
   def update
      @sms_sends_search=SmsSendsSearch.create!(permit_params)
      redirect_to @sms_sends_search
   end

   private
     def permit_params
	   params.require(:sms_sends_search).permit(:sms_id, :recv_num, :send_content, :state, :sms_type, :user_name, :sms_created, :id)
   end

end
