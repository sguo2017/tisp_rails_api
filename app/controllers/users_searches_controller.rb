class UsersSearchesController < ApplicationController
  
   before_action :authenticate_user!

   # 创建搜索
   # 创建完成后重定向到#show
   # POST => /users_search
   def create
      @users_search=UsersSearch.create!(permit_params)
      redirect_to @users_search
   end

   # 展示搜索
   # 这里渲染主页
   # GET => /users_search/:id
   def show
      @users_search=UsersSearch.find(params[:id])
	  @users=@users_search.users.order("created_at DESC").page(params[:page]).per(10)
	  @selected_level =  (Const::USER_LEVELS.select{|x| x == @users_search.user_level}).flatten
	  @selected_admin =  (Const::BOOLEAN_LIST.select{|x| x[1] == @users_search.is_admin}).flatten
	  @selected_locked =  (Const::BOOLEAN_LIST.select{|x| x[1] == @users_search.has_locked}).flatten
      render 'users_manager/index'
   end

   #更新搜索
   #并非一般意义上的更新数据库中的搜索对象，而是同update一样创建一个新的搜索
   #PUTCH => /users_search/:id
   def update
      @users_search=UsersSearch.create!(permit_params)
      redirect_to @users_search
   end

   private
     def permit_params
	   params.require(:users_search).permit(:user_id, :user_email, :user_name, :is_admin, :user_level, :has_locked, :user_created, :id)
   end

end
