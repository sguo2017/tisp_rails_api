class AdminUsersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :lock_proc]
  #这里不要使用 load_and_authorize_resource，否则更新会出错，原因未明
  before_action :authorize_user
  before_action :set_users_search

  # GET /users
  # GET /users.json
  def index
    @users = User.order("created_at DESC").page(params[:page]).per(10)
	render 'users_manager/index'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render 'users_manager/show'
  end

  # GET /users/new
  def new
    @target_user = User.new
	render 'users_manager/new'
  end

  # GET /users/1/edit
  def edit
    render 'users_manager/edit'
  end

  # POST /users
  # POST /users.json
  def create
    authorize! :create, User
    @target_user = User.new(user_params)
    respond_to do |format|
      if @target_user.save
        format.html { redirect_to admin_user_path(@target_user), notice: '用户创建成功' }
      else
        format.html { render 'users_manager/new' }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if update_user(user_params)
        format.html { redirect_to admin_user_path(@target_user), notice: '用户更新成功' }
      else
        format.html { render 'users_manager/edit' }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @target_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: '用户删除成功' }
    end
  end

  #GET/POST
  def lock_proc
    if @target_user.admin
  	  false
    elsif @target_user.has_locked?
  	  @target_user.unlock
      Jpush.singleMsgPushV2(@target_user.regist_id, Const::JPushTemplate::UNLOCK_USER, Const::JPushTemplate::TYPE[:unlock_user], @target_user.device_type)
  	else
  	  @target_user.lock_it
      Jpush.singleMsgPushV2(@target_user.regist_id, Const::JPushTemplate::LOCK_USER, Const::JPushTemplate::TYPE[:lock_user], @target_user.device_type)
  	end
	  redirect_to admin_users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @target_user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :admin, :avatar, :level)
    end

	def update_user(params)
	    if params[:password].blank?
		   params.delete(:password)
		   params.delete(:password_confirmation)
		end
		return  @target_user.update(params)
	end

	#验证用户权限
	def authorize_user
       authorize!(params[:action].to_sym, @target_user || User)
	end

	def set_users_search
	    if !@users_search
            @users_search=UsersSearch.new
        end
	end

end
