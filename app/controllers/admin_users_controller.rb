class AdminUsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
	render 'users/index'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render 'users/show'
  end

  # GET /users/new
  def new
    @target_user = User.new
	render 'users/new'
  end

  # GET /users/1/edit
  def edit
    render 'users/edit'
  end

  # POST /users
  # POST /users.json
  def create
    @target_user = User.new(user_params)
    respond_to do |format|
      if @target_user.save
        format.html { redirect_to admin_user_path(@target_user), notice: '用户创建成功' }
      else
        format.html { render 'users/new' }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @target_user.update(user_params)
        format.html { redirect_to admin_user_path(@target_user), notice: '用户更新成功' }
      else
        format.html { render 'users/edit' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @target_user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :admin, :avatar)
    end
end